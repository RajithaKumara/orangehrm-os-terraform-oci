resource "oci_core_vcn" "simple" {
  count          = local.use_existing_network ? 0 : 1
  cidr_block     = var.vcn_cidr_block
  dns_label      = substr(var.vcn_dns_label, 0, 15)
  compartment_id = var.compartment_ocid
  display_name   = var.vcn_display_name

  freeform_tags = { (var.tag_key_name) = (var.tag_value) }
}

#IGW
resource "oci_core_internet_gateway" "simple_internet_gateway" {
  count          = local.use_existing_network ? 0 : 1
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.simple[count.index].id
  enabled        = "true"
  display_name   = "${var.vcn_display_name}-igw"

  freeform_tags = { (var.tag_key_name) = (var.tag_value) }
}

#simple subnet
resource "oci_core_subnet" "simple_subnet" {
  count                      = local.use_existing_network ? 0 : 1
  cidr_block                 = var.subnet_cidr_block
  compartment_id             = var.compartment_ocid
  vcn_id                     = oci_core_vcn.simple[count.index].id
  display_name               = var.subnet_display_name
  dns_label                  = substr(var.subnet_dns_label, 0, 15)
  prohibit_public_ip_on_vnic = false

  route_table_id    = oci_core_route_table.simple_route_table[0].id
  security_list_ids = [oci_core_security_list.public_security_list_ssh.id, oci_core_security_list.public_security_list_http.id, oci_core_security_list.private_security_list.id]

  freeform_tags = { (var.tag_key_name) = (var.tag_value) }
}

resource "oci_core_route_table" "simple_route_table" {
  count          = local.use_existing_network ? 0 : 1
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.simple[count.index].id
  display_name   = "${var.subnet_display_name}-rt"

  route_rules {
    network_entity_id = oci_core_internet_gateway.simple_internet_gateway[count.index].id
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
  }

  freeform_tags = { (var.tag_key_name) = (var.tag_value) }
}

resource "oci_core_route_table_attachment" "route_table_attachment" {
  count          = local.use_existing_network ? 0 : 1
  subnet_id      = oci_core_subnet.simple_subnet[count.index].id
  route_table_id = oci_core_route_table.simple_route_table[count.index].id
}

data "oci_core_vnic_attachments" "orangehrm_vnics" {
  depends_on          = [oci_core_instance.orangehrm]
  compartment_id      = var.compartment_ocid
  availability_domain = local.availability_domain
  instance_id         = oci_core_instance.orangehrm.id
}

data "oci_core_vnic" "orangehrm_vnic1" {
  depends_on = [oci_core_instance.orangehrm]
  vnic_id    = data.oci_core_vnic_attachments.orangehrm_vnics.vnic_attachments[0]["vnic_id"]
}

data "oci_core_private_ips" "orangehrm_private_ips1" {
  depends_on = [oci_core_instance.orangehrm]
  vnic_id    = data.oci_core_vnic.orangehrm_vnic1.id
  subnet_id  = oci_core_subnet.simple_subnet[0].id
}

resource "oci_core_public_ip" "orangehrm_public_ip_for_single_node" {
  depends_on     = [oci_core_instance.orangehrm]
  compartment_id = var.compartment_ocid
  display_name   = "orangehrm_public_ip_for_single_node"
  lifetime       = "RESERVED"
  private_ip_id  = data.oci_core_private_ips.orangehrm_private_ips1.private_ips[0]["id"]
}

# Security
resource "oci_core_security_list" "public_security_list_ssh" {
  compartment_id = var.compartment_ocid
  display_name   = "Allow Public SSH Connections"
  vcn_id         = oci_core_vcn.simple[0].id
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "6"
  }
  ingress_security_rules {
    tcp_options {
      max = 22
      min = 22
    }
    protocol = "6"
    source   = "0.0.0.0/0"
  }
}

resource "oci_core_security_list" "public_security_list_http" {
  compartment_id = var.compartment_ocid
  display_name   = "Allow HTTP(S)"
  vcn_id         = oci_core_vcn.simple[0].id
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "6"
  }
  ingress_security_rules {
    tcp_options {
      max = 80
      min = 80
    }
    protocol  = "6"
    source    = "0.0.0.0/0"
    stateless = true
  }
  ingress_security_rules {
    tcp_options {
      max = 443
      min = 443
    }
    protocol  = "6"
    source    = "0.0.0.0/0"
    stateless = true
  }
}


resource "oci_core_security_list" "private_security_list" {
  compartment_id = var.compartment_ocid
  display_name   = "Private"
  vcn_id         = oci_core_vcn.simple[0].id

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }
  ingress_security_rules {
    protocol = "1"
    source   = var.vcn_cidr_block
  }
  ingress_security_rules {
    tcp_options {
      max = 22
      min = 22
    }
    protocol = "6"
    source   = var.vcn_cidr_block
  }
  ingress_security_rules {
    tcp_options {
      max = 3306
      min = 3306
    }
    protocol = "6"
    source   = var.vcn_cidr_block
  }
}
