#!/usr/bin/env python3
from datetime import datetime
import socket
import ssl
import sys
import OpenSSL


def get_certificate(host, port=443, timeout=10):
    context = ssl.create_default_context()
    conn = socket.create_connection((host, port))
    sock = context.wrap_socket(conn, server_hostname=host)
    sock.settimeout(timeout)
    try:
        der_cert = sock.getpeercert(True)
    finally:
        sock.close()
    return ssl.DER_cert_to_PEM_cert(der_cert)


def main():
    hostname = sys.argv[1]
    port = int(sys.argv[2])
    daysleft = int(sys.argv[3])
    enable_sni = sys.argv[4].lower() in ['true', '1', 'y', 'yes']
    
    if enable_sni:
        cert = get_certificate(hostname, port)
    else:
        # get_server_certificate((hostname, port)) doesn't work properly with SNI
        cert = ssl.get_server_certificate((hostname, port))
    x509 = OpenSSL.crypto.load_certificate(OpenSSL.crypto.FILETYPE_PEM, cert)

    notAfter = datetime.strptime(
        x509.get_notAfter().decode('ascii'), '%Y%m%d%H%M%SZ')
    delta = notAfter - datetime.now()

    print("(%s days left) %s:%s valid until %s" %
          (delta.days, hostname, port, notAfter))

    if delta.days > daysleft:
        sys.exit(0)
    else:
        sys.exit(1)


if __name__ == '__main__':
    main()
