# simpler frappe docker 

## install

### Create your copies of example files
```bash
cp example.env .env
```
```bash
cp frappe/development/apps-example.json frappe/development/apps.json
```
- in `.env` file add your configs
- in `apps.json` file add your apps urls

### in docker-compose.yml file
if you require git cloning for your apps 
 uncomment this:
  `
  #- ${HOME}/.ssh:/home/frappe/.ssh
  `

Modify ports as you wish (or keep them as they are):

```yml

  frappe:
    # ...
    volumes:
      - ./frappe:/workspace:cached
      # Enable if you require git cloning
      #- ${HOME}/.ssh:/home/frappe/.ssh
    working_dir: /workspace/development
    ports:
      - 8000-8005:8000-8005
      - 9000-9005:9000-9005
    # ...
```


### compose up


>[!note]
>In the first compose-up it will take a long time, in order to install applications, deps and packages.




```bash
docker compose up -d
```