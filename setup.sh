# cleanup
oc delete project/dev
oc delete project/test
oc delete project/prod

#setup
oc new-project dev
oc new-project test
oc new-project prod
oc policy add-role-to-user system:image-puller system:serviceaccount:test:default -n dev
oc policy add-role-to-user system:image-puller system:serviceaccount:prod:default -n test
oc new-project ci
oc new-app jenkins-ephemeral -n ci
oc policy add-role-to-user edit system:serviceaccount:ci:jenkins -n dev
oc policy add-role-to-user edit system:serviceaccount:ci:jenkins -n test
oc policy add-role-to-user edit system:serviceaccount:ci:jenkins -n prod

# create pipeline in ci
oc project ci
oc create -f https://github.com/nstrug/tomcat-docker/blob/master/pipeline

#create buildconfig in dev
oc project dev
oc new-app registry.access.redhat.com/jboss-webserver-3/webserver30-tomcat8-openshift~https://github.com/nstrug/tomcat-docker --name tomcat-sample-app
oc tag dev/tomcat-sample-app:latest dev/tomcat-sample-app:readyfortest -n dev

# create deploymentconfig in test
oc tag dev/tomcat-sample-app:readyfortest test/tomcat-sample-app:test -n test
oc new-app test/tomcat-sample-app:test -n test

# create deployment config prod
oc tag test/tomcat-sample-app:test test/tomcat-sample-app:readyforprod -n test
oc tag test/tomcat-sample-app:readyforprod prod/tomcat-sample-app:prod -n prod
oc new-app prod/tomcat-sample-app:prod -n prod



