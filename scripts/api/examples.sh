#!/usr/bin/env bash
#
# There are examples of Topological API/Sources API calls
# You can use file api/dev.sh (in gitignore)

source "api/common.sh"
#
# LIST tenants ------------------
#
# topological_api_get "tenants?filter[id]=2" "internal/v1.0"
# echo ""
# topological_api_get "tenants" "internal/v0.0"
# echo ""
#
# SOURCES --------------------
#
# GET Source Type
# response=`sources_api_get "source_types?filter[name]=amazon"`
# echo ${response} | jq '.'
#
# GET Sources
# sources_api_get 'sources'
# echo ""
# topological_api_get 'sources'
# echo ""

# CREATE Source
# sources_api_post "sources" "{\"name\":\"Mock Source 1\",\"source_type_id\":\"4\"}"
# echo ""
#

# UPDATE Source
# sources_api_patch "sources/2" "{\"name\": \"Openshift Source\"}"
# echo ""
#

# DELETE Source
# sources_api_delete "sources/1"
# echo ""
#

# APPLICATIONS (complex filter) -----

# GET applications which must be added (at least 1) to Source for creating Collector's pod
# sources_api_get "applications?filter[application_type_id][eq][]=1&filter[application_type_id][eq][]=3"
# echo ""

# EXAMPLES OF CREATING SOURCE WITH RELATIONS ---

#sources_api_post "sources" "{\"uid\": \"1111\",\"name\":\"Azure 1\",\"source_type_id\":\"3\", \"availability_status\": \"available\"}"
#sources_api_post "endpoints" "{\"source_id\":\"9\",\"default\":\"true\",\"path\":\"/\"}"
#sources_api_post "authentications" "{\"resource_type\":\"Endpoint\",\"resource_id\":\"6\",\"authtype\":\"tenant_id_client_id_client_secret\",\"username\":\"redhat\",\"password\":\"redhat\",\"extra\":{\"azure\":{\"tenant_id\":\"12345\"}}}"
#sources_api_post "applications" "{\"source_id\":\"9\",\"application_type_id\":\"4\",\"availability_status\":\"available\"}"

# GRAPHQL -----------------------

# sources_api_post "graphql" "{\"query\": \"{ sources { id, created_at, source_type_id, name, tenant, uid, updated_at applications { application_type_id, id }, endpoints { id, scheme, host, port, path } }}\"}"

# SOURCE AVAILABILITY CHECK -----
# sources_api_post "sources/4/check_availability"

# CATALOG ORDERING --------------
# Job template (ServiceOffering)
# topological_api_post "service_offerings/2/order" "{\"service_parameters\":{\"username\":\"mslemr\",\"quest\":\"Test Topology\",\"airspeed\":50},\"provider_control_parameters\":{}}"

# Workflow Job template (ServiceOffering)
# topological_api_post "service_offerings/5/order" "{\"service_parameters\":{\"dev_null\":\"Yes\"},\"provider_control_parameters\":{}}"

# Applied Inventories operation (before ordering - Approval operation)
# topological_api_post "service_offerings/569/applied_inventories" "{}"

echo ""