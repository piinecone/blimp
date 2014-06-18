Blimp
=====

Blimp keeps large files out of your git repo by storing them on S3. I wrote Blimp to keep my game development repositories small. I needed something that would run on OS X and Windows with minimal setup. Lastly, using it had to be simple enough for people with limited git experience.

Dependencies
------------

* ruby
* git
* aws-sdk gem
* aws s3 account and bucket

Installation
------------

### OS X ###

* `gem install aws-sdk`
* `git clone git@github.com:piinecone/blimp.git /cool/blimp/path/`
* add /cool/blimp/path/bin to your $PATH; e.g.:

   `echo 'export PATH=$PATH:/cool/blimp/path/bin' >> ~/.bash_profile`

* export `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment variables; e.g.:

```
   echo 'export AWS_ACCESS_KEY_ID=blimpman5000' >> ~/.bash_profile
   echo 'export AWS_SECRET_ACCESS_KEY=letmein' >> ~/.bash_profile
```

* ensure `which blimp` returns something
* ensure /cool/blimp/path/bin/blimp is executable (chmod +x blimp)

### Windows ###

* install ruby (http://rubyinstaller.org/) (allow it to add ruby to your $PATH)
* install git and [git bash for windows](http://git-scm.com/downloads)
* run git bash
* `gem install aws-sdk`
* `git clone git@github.com:piinecone/blimp.git ~/cool/blimp/path/`
* add ~/cool/blimp/path/bin to your $PATH; e.g.:

   `echo 'export PATH=$PATH:~/cool/blimp/path/bin' >> ~/.bash_profile`

* export `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment variables; e.g.:

```
   echo 'export AWS_ACCESS_KEY_ID=blimpman5000' >> ~/.bash_profile
   echo 'export AWS_SECRET_ACCESS_KEY=letmein' >> ~/.bash_profile
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

Todos
-----

* Optimize `blimp push` by skipping files that haven't changed and updating their S3 locations to the current SHA
* Do not upload or download files matching patterns listed in .blimpignore
* Update `blimp status` to show only the files that differ from their remote counterparts
* Create an automated test suite

Contributing
------------
