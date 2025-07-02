output "jenkins_master_ip" {
  value = module.jenkins_master.public_ip
}

output "agent_node_ip" {
  value = module.agent_node.public_ip
}
