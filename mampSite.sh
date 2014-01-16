#!/bin/bash
# A quick and dirty bash script to quickly setup new local sites and
# automatically add vhost configuration and hosts file entry and
# start with either a new wordpress installation or the HTML5 boilerplate template


# Prompt User for site name
echo "Enter the dev URL (e.g. sitename.dev) of the site you'd like to create, followed by [ENTER]:"
read site_url

# Redisplay site name and prompt to continue
echo "You entered $site_url is that correct? [Y/N]"
read is_correct

if [ "$is_correct" == "Y" ] || [ "$is_correct" == "y" ] ; then

    # Path to new site document root
    SITE_DIR="$HOME/Sites/$site_url"

    # Path to Apache vhosts config file
    VHOST_FILE="/Applications/MAMP/conf/apache/extra/httpd-vhosts.conf"

    if [ -d $SITE_DIR ] ; then
        # Directory already exists
        # Don't create it or add vhost config

        echo "$SITE_DIR already exists"
        echo "VHOST definition will not be added"

    else
        # Directory doesn't exist

        # Create directory
        echo "Creating $SITE_DIR ..."
        mkdir $SITE_DIR

        # Add site definition to vhosts config

        echo "Adding VHOST definition ..."

cat >> "$VHOST_FILE" <<EOF

<VirtualHost 127.0.0.1:80>
    ServerName $site_url
    DocumentRoot "$SITE_DIR/"
    <Directory "$SITE_DIR/">
        AllowOverride All
    </Directory>
</VirtualHost>
EOF

        #Add site name to hosts file and hosts.ac file (cisco vpn config file)
        echo "Adding site name to hosts file (using sudo)"
        echo "127.0.0.1 $site_url" | sudo tee -a /etc/hosts && echo "127.0.0.1 $site_url" | sudo tee -a /etc/hosts.ac


        # Wordpress install prompt
        echo "Install Wordpress? [Y/N]"
        read install_wordpress

        if [ "$install_wordpress" == "Y" ] || [ "$install_wordpress" == "y" ] ; then
            echo "Downloading Wordpress"

            # Go to the site directory
            cd $SITE_DIR

            # Get the latest version of Wordpress and unzip when the download is complete
            curl -O http://wordpress.org/latest.zip && unzip "$SITE_DIR/latest.zip"

            # The zip file was successfully unzip and wordpress directory exists
            if [ -d "$SITE_DIR/wordpress" ] ; then
                echo "Moving Wordpress files to the site root"

                # Go to wordpress directory and move everything to the site root
                cd "$SITE_DIR/wordpress" && mv * ../

                # Go back to site root
                cd ..

                # Remove empty wordpress directory
                rmdir "$SITE_DIR/wordpress"

                # Remove wordpress zip file
                rm "$SITE_DIR/latest.zip"

                # Create a copy of the config file
                cp ./wp-config-sample.php ./wp-config.php
            fi

        else

            # HTML5 BP install prompt
            echo "Install HTML5BP? [Y/N]"
            read install_html5bp

            if [ "$install_html5bp" == "Y" ] || [ "$install_html5bp" == "y" ] ; then
                echo "Installing HTML5BP"

                # Go to the site directory
                cd $SITE_DIR

                # clone html5 repo
                git clone git@github.com:h5bp/html5-boilerplate.git .

                # remove .git files
                rm -rf .git

            fi

        fi

    fi

fi

echo "Done!"
echo "Don't forget to restart apache"