# riak-ruby-docker

Docker image for testing riak-ruby-client with Riak 2.

## Usage

```bash
$ docker run -d -p 17017:8087 -p 17018:8098 holidayworking/riak-ruby-docker
```

**Note:** If you're using [boot2docker](https://github.com/boot2docker/boot2docker) ensure that you forward the virtual machine port (17017, 17018).

```bash
$ VBoxManage controlvm "dev" natpf1 "riak-pb,tcp,127.0.0.1,17017,,17017"
$ VBoxManage controlvm "dev" natpf1 "riak-http,tcp,127.0.0.1,17018,,17018"
```

## Author

Author:: Hidekazu Tanaka (<hidekazu.tanaka@gmail.com>)
