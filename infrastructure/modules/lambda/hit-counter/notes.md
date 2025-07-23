ok so here is how i think the CI/CD pipeline will work here:

1. Push golang changes to github
2. build binary
3. run tests on that binary
4. if tests pass, zip up the binary
5. run terraform apply action to upload the binary

I think that's it?

But first I want this terraform to be a self contained module for lambda, and I also need to remove the building the zip

OK SMALL CHANGE

just because of the way terraform stores state, i don't want to actually run any terraform stuff through github

it would be the right way to do it, but I don't want to incur charges from AWS for managing the state file

so I used this guide to set up the github action

https://blog.devgenius.io/deploy-the-golang-app-to-aws-lambda-using-github-action-66e351466e7a

Now that I'm looking at how bit the actual state is... maybe I can do the remote state?