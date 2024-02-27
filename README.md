# jekyll-docker

### Sample Usage

```yaml
  jekyll:
    image: ${DCK_USER}/${PROJ_KEY}-jekyll${DCK_TAG}
    build:
      context: _d/jekyll
      target: jekyll-server
    restart: 'no'
    #command: jekyll serve --force_polling --drafts --trace
    develop:
      watch:
        - action: rebuild
          path: ./_d/jekyll
          ignore:
            - docs/
    volumes:
      - nfs-docs:/docs
```
