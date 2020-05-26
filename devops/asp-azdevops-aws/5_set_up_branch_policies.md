# Setting up branch policies in Azure DevOps

### A simple GitFlow-ish branch system

__Branches:__
 - _master_ represents the canonical, latest release of the code that is in production. _master_ is completely stable. _master_ is tagged with release numbers (v 0.1, v 1.0, v.1.1, etc.). The only branches that form from _master_ are hot fix branches.
 - _Development_ is the unstable branch with the latest completed, tested features. All active feature development branches from this branch.
 - _Release_ contains a set of tested features that can potentially be released. When a release is ready, a _Release_ branch is forked from _Development_. Higher-level tests (integration, UI, etc) are done here and patches are made from _Release_ code. When a release is determined to be ready for production, release is merged into _master_ with a version tag, then it is merged into _Development_ and new feature development begins again. What's important is that once a _Release_ branch is made, no other changes from the _Development_ branch can be added until the final deployment.
 - _HotFix_ is the only branch to fork from _master_. This is only to fix bugs found into production. Once the fix is made, the branch is merged into _master_ and the _Development_ branch.
 - _Feature_ branches contain ongoing feature work. The code in these branches may be broken until the feature is fully developed and tested. Once the feature is finished, it's merged back into _Development_ to be incorporated into the other development work.

In __Azure DevOps__:
 - Create a pipeline that will build and run tests on the code.
 - From the side menu: Repos (open accordion) > Branches [Create needed branches if they're not there] > : More > Branch Policies > Add build policy > Build pipeline [select pipeline from previous step] > Automatic or Manual > Required or Optional > Build expiration policy

 Now when a pull request is made to the branch (especially Development), the branch policy will ensure that the code can compile and tests pass.






