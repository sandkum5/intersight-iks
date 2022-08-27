"""
    Module to get an Organization Moid
    Create an Organization relationship object
    Return org_rel object
"""
from intersight.model.organization_organization_relationship \
    import OrganizationOrganizationRelationship
from intersight.api.organization_api import OrganizationApi
import logging

log = logging.getLogger(__name__)


def get_org_rel(api_client, org_name):
    """
    Function to get Organization Relationship
    """
    api_instance = OrganizationApi(api_client)
    try:
        org_data = (api_instance.get_organization_organization_list())['results']
    except Exception as exception:
        print(f"Exception when calling orgApi->get_organization_organization_list: {exception}\n")

    if org_data:
        org_moid = [org['moid'] for org in org_data if org['name'] == org_name][0]
        org_rel = OrganizationOrganizationRelationship(
            class_id    = "mo.MoRef",
            object_type = "organization.Organization",
            moid        = org_moid
        )
        return org_rel
    return None
