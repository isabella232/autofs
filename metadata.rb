name 'autofs'
maintainer 'University of Derby'
maintainer_email 'its-chef@derby.ac.uk'
license 'Apache-2.0'
description 'Configures the autofs service'
version '2.0.2'
source_url 'https://github.com/universityofderby/chef-autofs'
issues_url 'https://github.com/universityofderby/chef-autofs/issues'
chef_version '>= 12'
supports 'redhat'

depends 'compat_resource', '~> 12.14'
depends 'chef-sugar', '~> 3.4'
depends 'line', '~> 1.0'
