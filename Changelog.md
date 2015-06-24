# DocRaptor Gem Changelog

## Untagged
* Add user agent for calls `expectedbehavior_doc_raptor_gem/<gem version> <ruby platform>/<version>`

## 0.3.4 - 2015/02/20
* Remove confusing Gemfile.lock.

## 0.3.3 - 2015/02/20
* Set encoding on tempfiles to avoid encoding issue on binary data.

## 0.3.2 - 2012/03/30
* Update the httparty requirement quite a bit as some of the methods
  we were using were from 0.7.0 (as opposed to the old >= 0.4.3)

## 0.3.1 - 2012/03/30
* update the README around async jobs, since it was still talking
  about the gem's behavior in 0.2.x

## 0.3.0 - 2012/03/29
* BUGFIX async create calls were incorrectly returning the status id
  instead of the response object
* More test (fixture) refactoring
* A little production code cleanup

## 0.2.3 - 2012/03/15
* major test refactor in preparation for bigger changes
* use current gem packaging techniques
* add rake into the mix so all the tests can be run with `rake` instead of `bundle exec ruby whatever`
* readme cleanup
* changelog cleanup
* added dates for all the versions to the changelog
* package all the files from the repo instead of just a few

## 0.2.2 - 2011/12/07
* BUG: forgot a file in the gem

## 0.2.1 - 2011/12/07
* BUG: there were certain envs where .blank? wasn't defined. So,
pulling in the core_ext from activesupport

## 0.2.0 - 2011/09/01
* added behavioral tests!
* added a create! method which will raise an exception when doc creation fails
* added a list_docs! method which will raise an exception when doc listing fails
* added a status! method which will raise an exception when getting an async status fails
* added a download! method which will raise an exception when getting an async status fails

## 0.1.6 - 2011/08/30
* allow the gem to be used outside without activesupport

## 0.1.5 - 2011/08/29
* BUG: activesupport safebuffers in rails ~3.0.6 and up were screwing up downloads

## 0.1.4 - 2011/06/24
* add support for creating async jobs

## 0.1.3 - 2011/01/29
* if a block is given to "create", make the value the block returns be the
  value create returns
* add list_doc method, for the new api call to list created documents

## 0.1.2 - 2010/12/02
* add support for the the document_url parameter to create
* reduce httparty requirement to 0.4.3

## 0.1 - 2010/10/29
* initial release
