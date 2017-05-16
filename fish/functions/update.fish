function update -d "Update mac, brew, npm and gem"

    if test -d /etc/debian_version

        sudo apt-get update; \
        and sudo apt-get upgrade; \
        and npm update npm -g; \
        and npm update -g; \
        and sudo gem update

    else

        sudo softwareupdate -i -a; \
        and brew update; brew upgrade; \
        and brew cleanup; \
        and npm update npm -g; \
        and npm update -g; \
        and sudo gem update

    end

end
