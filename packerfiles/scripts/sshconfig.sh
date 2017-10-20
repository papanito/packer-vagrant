#!/bin/sh
set -e
set -x

echo "Configure ssh key"
mkdir ~/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDBlFAqai9Me85YOOWxvErxzWO8X9kaE9mxdH1JP9GZPo0svbRr8v5r8LLCITctAC2x+QgUMjUK2Xk5PA5skw8n1R8ygrT1z93K+kxrd6+dxwMlyFDppExm0jlfuUOvqY+wQWLGFTbcRLhKo5VeZ6NkFh/YrjxZe/vQbNeEjZSuJtKfhmcMj6VgysC24RdUF3oIXsAnhexVaHkRvMe6C+6xY6IAX64+LDLHikmVyqOlJlk+uBREzW/4P/G3zBFAG13m0SKXJTD/nUIGF5wEaynza8UypK1YZBgSZUc+rBOUsn6Wqm+ih2godx3KDG4Ddjm/qcQcI3KS5yANSlvGLStZ ssh key for @username@" > ~/.ssh/authorized_keys
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys