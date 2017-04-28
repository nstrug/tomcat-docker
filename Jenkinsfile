node('maven') {
    stage 'dev-build'
    openshiftBuild(namespace: 'dev', buildConfig: 'tomcat-sample-app', showBuildLogs: 'true')

    stage 'dev-verify-deploy'
    openshiftVerifyDeployment(namespace: 'dev', depCfg: 'tomcat-sample-app')

    stage 'dev-tag-readyfortest'
    openshiftTag(namespace: 'dev', destinationNamespace: 'dev', srcStream: 'tomcat-sample-app', srcTag: 'latest', destStream: 'tomcat-sample-app', destTag:'readyfortest')

    stage 'test-tag-testing'
    openshiftTag(namespace: 'dev', destinationNamespace: 'test', srcStream: 'tomcat-sample-app', srcTag: 'readyfortest', destStream: 'tomcat-sample-app', destTag:'test')

    stage 'test-verify-deploy'
    openshiftVerifyDeployment(namespace: 'test', depCfg: 'tomcat-sample-app')

    stage 'test-tag-readyforprod'
    openshiftTag(namespace: 'test', destinationNamespace: 'test', srcStream: 'tomcat-sample-app', srcTag: 'test', destStream: 'tomcat-sample-app', destTag:'readyforprod')

    stage 'prod-tag-prod'
    openshiftTag(namespace: 'test', destinationNamespace: 'prod', srcStream: 'tomcat-sample-app', srcTag: 'readyforprod', destStream: 'tomcat-sample-app', destTag:'prod')

    stage 'prod-verify-deploy'
    openshiftVerifyDeployment(namespace: 'prod', depCfg: 'tomcat-sample-app')

    stage 'prod-scale-up'
    openshiftScale(namespace: 'prod', depCfg: 'tomcat-sample-app', replicaCount: '2')

    stage 'prod-verify-replicacount'
    openshiftVerifyDeployment(namespace: 'prod', depCfg: 'tomcat-sample-app', replicaCount: '2', verifyReplicaCount: 'true')
}
