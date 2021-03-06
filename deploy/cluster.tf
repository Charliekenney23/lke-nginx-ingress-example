resource "linode_lke_cluster" "cluster" {
    label       = "hello-kube-cluster"
    k8s_version = "1.17"
    region      = "us-east"
    tags        = ["test"]

    pool {
        type  = "g6-standard-2"
        count = 3 
    }
}

# The kubeconfig will be decoded and written to the k8s
# directory when updated.
resource "null_resource" "kubeconfig_fetch" {
    triggers = {
        kubeconfig = linode_lke_cluster.cluster.kubeconfig
    }
    
    provisioner "local-exec" {
        command = "mkdir -p ../k8s/.config && echo '${base64decode(linode_lke_cluster.cluster.kubeconfig)}' > ../k8s/.config/kubeconfig.yaml"
    }
}
