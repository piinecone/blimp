Blimp
=====

Blimp keeps large files out of your git repo by storing them on S3. I wrote Blimp to keep my game development repositories small. I needed something that would run on OS X and Windows with minimal setup. Lastly, using it had to be simple enough for people with limited git experience.

Dependencies
------------

* ruby
* git
* aws-sdk gem
* aws-sdk-core gem
* aws s3 account and bucket

Installation
------------

### OS X ###

* `gem install aws-sdk`
* `gem install aws-sdk-core --pre`
* `git clone git@github.com:piinecone/blimp.git /cool/blimp/path/`
* add /cool/blimp/path/bin to your $PATH; e.g.:

   `echo 'export PATH=$PATH:/cool/blimp/path/bin' >> ~/.bash_profile`

* export `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_DEFAULT_REGION` environment variables; e.g.:

```
   echo 'export AWS_ACCESS_KEY_ID=blimpman5000' >> ~/.bash_profile
   echo 'export AWS_SECRET_ACCESS_KEY=letmein' >> ~/.bash_profile
   echo 'export AWS_DEFAULT_REGION=us-east-1' >> ~/.bash_profile
```

* ensure `which blimp` returns something
* ensure /cool/blimp/path/bin/blimp is executable (chmod +x blimp)

### Windows ###

* install ruby (http://rubyinstaller.org/) (allow it to add ruby to your $PATH)
* install git and [git bash for windows](http://git-scm.com/downloads)
* run git bash
* `gem install aws-sdk`
* `gem install aws-sdk-core --pre`
* `git clone git@github.com:piinecone/blimp.git ~/cool/blimp/path/`
* add ~/cool/blimp/path/bin to your $PATH; e.g.:

   `echo 'export PATH=$PATH:~/cool/blimp/path/bin' >> ~/.bash_profile`

* export `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_DEFAULT_REGION` environment variables; e.g.:

```
   echo 'export AWS_ACCESS_KEY_ID=blimpman5000' >> ~/.bash_profile
   echo 'export AWS_SECRET_ACCESS_KEY=letmein' >> ~/.bash_profile
   echo 'export AWS_DEFAULT_REGION=us-east-1' >> ~/.bash_profile
```

* ensure `which blimp` returns something
* ensure ~/cool/blimp/path/bin/blimp is executable (chmod +x blimp)

Usage
-----

#### From a new repo: ####

* cd ~/codebase/with/big/files
* `git init`
* `blimp init`
* set the blimp bucket name in `.git/config`
* `blimp watch *.big_file_extension` to .gitignore these files and manage them with blimp
* ... work / `git add` / `git commit` / `git push` ...
* `blimp status`
* `blimp push`

#### In an existing repo: ####

* `git clone internet://codebase/with/big/files`
* `blimp init`
* set the bucket name in `.git/config`
* `blimp pull` to download files from S3 for the current SHA
* ... work / `git add` / `git commit` / `git push` ...
* `blimp status` to see what will be committed (sort of; it's just `git status -b -s --ignored`)
* `blimp push` to upload files matching patterns in `.blimp` to the specified S3 bucket

How it works
------------

Caveats
-------

Todo
----

* Integrate with `git`
* Don't add file extensions to `.gitignore`, instead allow `git` to version references to the files
* Skip files listed in `.gitignore`
* Do not overwrite files if versions differ; instead, create `filename_#{sha}.extension`
* Add a `blimp prune` command to delete S3 objects from older revisions
* Only `blimp push` and `blimp pull` files that have changed according to git
* Update `blimp status` to show only the files that differ from their remote counterparts
* Attach git history as metadata to S3 objects
* Create an automated test suite
* Reduce dependencies

Contributing
------------
