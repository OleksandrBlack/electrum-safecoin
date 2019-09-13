AppImage binary for Electrum-SafeCoin
================================

This assumes an Ubuntu host, but it should not be too hard to adapt to another
similar system. The docker commands should be executed in the project's root
folder.

0. Clone locales (temporary, needs to be added to script)

     ``` 
     $ cd contrib/deterministic-build
     $ git clone https://github.com/OleksandrBlack/electrum-locale
     ```

1. Install Docker

    ```
    $ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    $ sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    $ sudo apt-get update
    $ sudo apt-get install -y docker-ce
    ```

2. Build image

    ```
    $ sudo docker build --no-cache -t electrum-safecoin-appimage-builder-img contrib/build-linux/appimage
    ```

3. Build binary

    ```
    $ sudo docker run -it \
        --name electrum-safecoin-appimage-builder-cont \
        -v $PWD:/opt/electrum-safecoin \
        --rm \
        --workdir /opt/electrum-safecoin/contrib/build-linux/appimage \
        electrum-safecoin-appimage-builder-img \
        ./build.sh
    ```

4. The generated binary is in `./dist`.


## FAQ

### How can I see what is included in the AppImage?
Execute the binary as follows: `./electrum*.AppImage --appimage-extract`
