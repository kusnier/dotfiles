function dump -d "dump to/from the internet"

    git -C ~/Documents/src/vaadin pull
    git -C ~/Documents/src/vaadin-lazyquerycontainer pull
    git -C ~/Documents/src/deltaspike pull

    git -C ~/Dropbox/src/cv-kusnier pull
    git -C ~/Dropbox/src/jenkins-seed pull

    git -C ~/Dropbox/src/camel-training pull
    git -C ~/Dropbox/src/jee-workshop pull
    git -C ~/Dropbox/src/vaadin-training/Vaadin\ Best\ Practices pull
    git -C ~/Dropbox/src/vaadin-training/Vaadin\ Client\ side pull
    git -C ~/Dropbox/src/vaadin-training/Vaadin\ Framework pull

    git -C ~/Dropbox/src/vagrant-persistent-storage pull

end
