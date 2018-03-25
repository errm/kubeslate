require "kubernetes"
require "kubernetes/utils"


module Kubeslate
  class Info
    def initialize
      Kubernetes.load_incluster_config
      @core = Kubernetes::CoreV1Api.new
      @extensions_v1_beta_1 = Kubernetes::ExtensionsV1beta1Api.new
      @version = Kubernetes::VersionApi.new
    end

    def version
      @version.get_code
    end

    def pod_count
      @core.list_pod_for_all_namespaces.items.size
    end

    def service_count
      @core.list_service_for_all_namespaces.items.size
    end

    def deployment_count
      @extensions_v1_beta_1.list_deployment_for_all_namespaces.items.size
    end
  end
end
