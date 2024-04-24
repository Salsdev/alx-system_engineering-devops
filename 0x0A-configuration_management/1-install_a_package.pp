# Puppet manifest to install Flask version 2.1.0 using pip3
# Install Werkzeug and Flask from pip3 using Puppet

package { 'Werkzeug':
    ensure   => '2.2.2',
    provider => 'pip3',
}

package { 'Flask':
    ensure   => '2.1.0',
    provider => 'pip3',
}
