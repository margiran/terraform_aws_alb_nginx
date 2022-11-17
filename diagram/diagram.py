#!/usr/bin/env python3

from mmap import PROT_READ
from diagrams import Diagram
from diagrams import Cluster, Diagram, Edge
from diagrams.custom import Custom
from diagrams.aws.compute import EC2 
from diagrams.onprem.network import Nginx
from diagrams.aws.network    import Route53,InternetGateway,NATGateway,ElbApplicationLoadBalancer
from diagrams.onprem.compute import Server

with Diagram("Load Balancing in the Cloud AWS NGINX Plus", show=False):
    client = Server("Client")
    with Cluster("VPC"):
        igw = InternetGateway("IGW")
        with Cluster("Public-SubNet"):
            nat_gw = NATGateway("Nat_gateWay")
            lb=ElbApplicationLoadBalancer("ALB")
        with Cluster("Private-SubNet"):
            ec2= EC2("Server")

        client >> lb
        lb >> ec2
        ec2 >> nat_gw
        nat_gw >> igw
        # lb >> igw
        # igw >> lb
           
