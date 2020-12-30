# Self-hosted Docker Registry

Using Let's Encrypt and this little script you can host a Docker registry for your private stuff

First make sure you have an SSL certificate. You should have a folder inside `/etc/letsencrypt/live/` with the domain of a certificate.

## Configuration

- Clone this project
- Create a file called `.env` in the root folder
- Add the following settings:

```
REGISTRY_HTTP_SECRET="<generate a very long and random key and add here>"
REGISTRY_SSL_FOLDER=<name of SSL folder inside /etc/letsencrypt/live/>
REGISTRY_PORT=<http port>
```

For example, for a registry under myregistry.com, with the secret key `123123`, this is what the env file looks like:

```
REGISTRY_HTTP_SECRET="123123"
REGISTRY_SSL_FOLDER="myregistry.com"
REGISTRY_PORT=1234
```

## Usage

#### Start registry

`bash docker.bash start`

#### Stop registry

`bash docker.bash stop`

#### Change registry credentials

`bash docker.bash update-password`

Username and password defined here are then used by `docker login` command

#### Update SSL certificates

`bash docker.bash update-certs`

Copies the SSL certificates from a folder in `/etc/letsencrypt/live/*` to use as the registry SSL certificates. 

See [configuration](https://github.com/cloud-cli/docker-registry#configuration) for details.

