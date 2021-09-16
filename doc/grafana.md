# Grafana dashboards

Grafana is a web application for monitoring status of services using graphs and charts. 

Development RH documentation can be found there:
- [Add a Grafana Dashboard](https://gitlab.cee.redhat.com/service/app-interface#add-a-grafana-dashboard)
- [Monitoring](https://gitlab.cee.redhat.com/service/app-interface/-/blob/master/docs/app-sre/monitoring.md#VisualizationwithGrafana)

## Dashboard location

Links to Grafana instances can be found in the links for stage/prod cluster (see [doc](https://gitlab.cee.redhat.com/service/app-interface/-/tree/master/docs/cloud.redhat.com/dev-onboarding#accessing-stage-environment)).  
In the Grafana, these dashboards are available under:

- Insights > Topological Inventory - Core
- Insights > Topological Inventory - APIs
- Insights > Topological Inventory - Collectors & Operations
- Insights > Sources 

## Dashboard definitions

Topological Inventory dashboards can be found in [Topological API repository](https://github.com/RedHatInsights/topological_inventory-api/tree/master/grafana-dashboards).  
Sources dashboards can be found in [Sources API repository](https://github.com/RedHatInsights/sources-api/tree/master/grafana-dashboards)

These ConfigMaps are generated from exported JSON. 

Dashboard can exported in Grafana by:
- Share dashboard > Export > View JSON

### Convert JSON to ConfigMap

App-Interface needs configmap for deployment of dashboard.  
The conversion script is located in [scripts/openshift/grafana-dashboard.sh](../scripts/openshift/grafana-dashboard.sh) script

Save the json to one of the dashboard folders above and run: 

```
oc login <some openshift>

cd <topological-api|sources-api>/grafana-dashboards

../../scripts/openshift/grafana-dashboard.sh -f <your-file.json>
```


## Publishing dashboard

The last operation is to release the dashboard to the App Interface. 

Update the [saas-grafana.yaml](https://gitlab.cee.redhat.com/service/app-interface#add-a-grafana-dashboard) and either add 
a new dashboard location or update the ref to the GitHub commit of your PR with change,

Example: [Initial PR](https://github.com/RedHatInsights/topological_inventory-api/pull/322) has a commit with SHA 
- 6c0cf9b030733ac4dac669a83636d7353f3fc800

*Note: Stage grafana points to the master branch of topo/sources api repos so changes are deployed automatically.*