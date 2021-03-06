[![Build Status](https://jenkins.sonata-nfv.eu/buildStatus/icon?job=son-cli)](https://jenkins.sonata-nfv.eu/job/son-cli/)


# son-cli
SONATA SDK command line interface tools

This set of command line tools are meant to aid the SONATA service developers on their tasks. The tools are briefly described as follows.
- `son-workspace` creates, configures and manages development workspaces and projects.
- `son-publish` allows the publication of projects, services and functions to private catalogues (in process to be integrated to `son-access`).
- `son-package` packages a project, containing services and functions, to be instantiated in the SONATA Service Platform. All project components are syntatically validated and external dependencies are retrieved to produce a complete service package.
- `son-push` is used to upload the service package to the Service Platform Gatekeeper (in process to be integrated to `son-access`).
- `son-monitor` provides tools to easily monitor/generate metrics for debugging and analyzing service performance.
- `son-access` enables authenticating users to the Service Platform and integrates features to push and pull resources from the Service Platform Catalogues.
    

## Building
To build the son-cli tools it is recommended the use of a virtual environment to avoid polluting your system and to offer isolation from the installed libraries on the host.

Prerequisites:
- python 3 (3.4 used for most of the development)
- virtualenv
- docker (used by son-monitor)
- docker-compose (used by son-monitor)

### Creating a virtualenv:
1. Install virtualenvwrapper using your distribution repositories or the pip package.
https://virtualenvwrapper.readthedocs.org/en/latest/
1. Create a virtualenv for this project 
`mkvirtualenv -p /usr/bin/python34 sonata`

### Clone and build the project
activate the virtualenv for the project `workon sonata` then clone the project and bootstrap and run buildout. This will download all the dependencies and creante the development environment.
```sh
git clone git@github.com:sonata-nfv/son-cli.git 
cd son-cli
python bootstrap.py
bin/buildout
```

If you are using pycharm, the IDE has support both for buildout and for virtualenvs,
please read their fine documentation on the subject before proceeding.

### Generated binaries
The buildout generates the binaries for the tools `son-workspace`, `son-publish`, `son-package`, `son-push` and `son-monitor`. Information on how to use the tools is detailed in Usage section bellow.

## Dependencies

The son-cli tools have the following dependencies:
* [pyaml](https://pypi.python.org/pypi/pyaml/) >= 15.8.2 (WTFPL)
* [jsonschema](https://pypi.python.org/pypi/jsonschema) >= 2.5.1 (MIT)
* [validators](https://pypi.python.org/pypi/validators) >= 0.10.3 (BSD)
* [requests](https://pypi.python.org/pypi/requests) >= 2.10 (Apache 2.0)
* [coloredlogs](https://pypi.python.org/pypi/coloredlogs) >= 5.0 (MIT)
* [paramiko](https://pypi.python.org/pypi/paramiko/1.16.0) >= 1.6 (LGPL)
* [docker-compose](https://docs.docker.com/compose/) >= 1.6.0 (Apache 2.0)
* [PyJWT](https://pypi.python.org/pypi/PyJWT/1.4.0) >= 1.4.0 (MIT)
* [Flask](http://flask.pocoo.org/) >= 0.11.1 (BSD)
* [numpy](https://pypi.python.org/pypi/numpy)  >= 1.11.3 (BSD)
* [scipy](https://pypi.python.org/pypi/scipy) >= 0.18.1 (BSD)


## Contributing

To contribute to son-cli this simple process should be followed:

1. Fork [this repository](http://github.com/sonata-nfv/son-cli);
2. Work on your proposed changes, preferably through submiting [issues](https://github.com/sonata-nfv/son-cli/issues);
3. Submit a Pull Request to the master branch;
4. Follow/answer related [issues](https://github.com/sonata-nfv/son-cli/issues) (see Feedback-Chanel, below).

## Installation

To install the SONATA CLI toolset in Ubuntu follow these steps:

1. Add the new GPG key
	```sh
	sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys D0DF34A30A4FE3F8
	```
    
2. Add a source entry for your Ubuntu OS.
    For now, supported distributions are supported:
    
- Ubuntu Trusty 14.04 (LTS)
    ```sh
    echo "deb http://registry.sonata-nfv.eu:8080 ubuntu-trusty main" | sudo tee -a /etc/apt/sources.list
    ```
    
- Ubuntu Xenial 16.04 (LTS)
    ```sh
    echo "deb http://registry.sonata-nfv.eu:8080 ubuntu-xenial main" | sudo tee -a /etc/apt/sources.list
    ```
    
3. Update and install
    ```sh
    sudo apt-get update
    sudo apt-get install sonata-cli
    ```

4. Test if its working by invoking:
    ```sh
    $ son-workspace -h
    $ son-package -h
    $ son-publish -h
    $ son-push -h
    $ son-monitor -h
    ```

## Usage
The usage guidelines of the son-cli tools are described as follows.

### son-workspace

Create workspaces and projects

This tool is responsible to create workspaces and generate project layouts.

```sh
usage: son-workspace [-h] [--init] [--workspace WORKSPACE] [--project PROJECT]
                     [--debug]

Generate new sonata workspaces and project layouts

optional arguments:
  -h, --help            show this help message and exit
  
  --init                Create a new sonata workspace
  
  --workspace WORKSPACE
                        location of existing (or new) workspace. If not
                        specified will assume '$HOME/.son-workspace'
                        
  --project PROJECT     create a new project at the specified location
  
  --debug               increases logging level to debug
```

Example on how to create an workspace and a project:

```sh
	son-workspace --init --workspace /home/user/workspaces/ws1
	son-workspace --workspace /home/user/workspace/ws1 --project /home/user/workspace/ws1/projects/p1
```

This example creates the workspace 'ws1' and a project 'p1' associated with it.

### son-package
Generate a SONATA SDK package.

This tool delivers a SON file compiling all the required descriptors of specified the project and workspace.

The generated file structure follows the format defined in the package-descriptor of the son-schema repository (https://github.com/sonata-nfv/son-schema/tree/master/package-descriptor). Please check folder examples for a demo package.

```sh
usage: son-package [-h] [--workspace WORKSPACE] [--project PROJECT]
                   [-d DESTINATION] [-n NAME]

Generate new sonata package

optional arguments:
  -h, --help            show this help message and exit
  --workspace WORKSPACE
                        Specify workspace to generate the package. If not
                        specified will assume '$HOME/.son-workspace'

  --project PROJECT     create a new package based on the project at the
                        specified location. If not specified will assume the
                        current directory.

  -d DESTINATION, --destination DESTINATION
                        create the package on the specified location

  -n NAME, --name NAME  create the package with the specific name
```

son-package will create a package inside the DESTINATION directory. If DESTINATION is not specified, the package will be deployed at <project root/target>.

Example on how to package a project:
```sh
    son-package --workspace /home/user/workspace/ws1 --project /home/user/project/prj1
```
Example on how to package a project with custom destination and package name:
```sh
    son-package --workspace /home/user/workspace/ws1 --project /home/user/project/prj1 --d /home/user/packages -n sonata-demo.son
```

### son-access
Authenticate the developer to gain access to the Service Platform.
Once authenticated, it allows the developer to submit packages to the Service Platform
Catalogues and request resources (packages and/or descriptors) from the Service Platform Catalogues.

```sh
usage: son-access [optional] command [<args>]
        The supported commands are:
           auth     Authenticate a user
           list     List available resources (service, functions, packages, ...)
           push     Submit a son-package
           pull     Request resources (services, functions, packages, ...)
           config   Configure access parameters


Authenticates users to submit and request resources from SONATA Service
Platform

positional arguments:
  command               Command to run

optional arguments:
  -h, --help            show this help message and exit
  -w WORKSPACE_PATH, --workspace WORKSPACE_PATH
                        Specify workspace to work on. If not specified will
                        assume '/root/.son-workspace'
  -p PLATFORM_ID, --platform PLATFORM_ID
                        Specify the ID of the Service Platform to use from
                        workspace configuration. If not specified will assume
                        the IDin 'default_service_platform'
  --debug               Set logging level to debug

```
Example on how to authenticate a user, submit a package file and retrieve resources:
```sh
    son-access auth -u tester -p 1234
    son-access list services
    son-access push samples/sonata-demo.son
    son-access pull packages --uuid 65b416a6-46c0-4596-a9e9-0a9b04ed34ea
    son-access pull services --id sonata.eu firewall-vnf 1.0
```

### son-validate

The son-validate tool can be used to validate the syntax, integrity and topology of SONATA SDK projects, services and functions. It receives the following arguments:

```sh
usage: son-validate [-h] [-w WORKSPACE_PATH]
                    (--project PROJECT_PATH | --package PD | --service NSD | --function VNFD)
                    [--dpath DPATH] [--dext DEXT] [--syntax] [--integrity]
                    [--topology] [--debug]

Validate a SONATA Service. By default it performs a validation to the syntax, integrity and network topology.

optional arguments:
  -h, --help            show this help message and exit
  -w WORKSPACE_PATH, --workspace WORKSPACE_PATH
                        Specify the directory of the SDK workspace for
                        validating the SDK project. If not specified will
                        assume the directory: '$HOME/.son-workspace'
  --project PROJECT_PATH
                        Validate the service of the specified SDK project. If
                        not specified will assume the current directory.
  --package PD          Validate the specified package descriptor.
  --service NSD         Validate the specified service descriptor. The
                        directory of descriptors referenced in the service
                        descriptor should be specified using the argument '--
                        path'.
  --function VNFD       Validate the specified function descriptor. If a
                        directory is specified, it will search for descriptor
                        files with extension defined in '--dext'
  --dpath DPATH         Specify a directory to search for descriptors.
                        Particularly useful when using the '--service'
                        argument.
  --dext DEXT           Specify the extension of descriptor files.
                        Particularly useful when using the '--function'
                        argument
  --syntax, -s          Perform a syntax validation.
  --integrity, -i       Perform an integrity validation.
  --topology, -t        Perform a network topology validation.
  --debug               sets verbosity level to debug
```

Some usage examples are as follows:
* validate a project: `son-validate --project /home/sonata/projects/project_X --workspace /home/sonata/.son-workspace`
* validate a service: `son-validate --service ./nsd_file.yml --path ./vnfds/ --dext yml`
* validate a function: `son-validate --function ./vnfd_file.yml --dext yml`
* validate multiple functions: `son-validate --function ./vnfds/ --dext yml`

### son-monitor
Monitor metrics of a deployed service (from the SONATA SDK emulator or Service Platform).
Generate and/or export metrics that are useful for debugging and analyzing the service performance.
```
usage: son-monitor [-h] [--vnf_names [VNF_NAMES [VNF_NAMES ...]]] [--vim VIM]
                   [--vnf_name VNF_NAME] [--datacenter DATACENTER]
                   [--image IMAGE] [--dcmd DOCKER_COMMAND] [--net NETWORK]
                   [--query QUERY] [--input INPUT] [--output OUTPUT]
                   [--source SOURCE] [--destination DESTINATION]
                   [--weight WEIGHT] [--match MATCH] [--priority PRIORITY]
                   [--bidirectional] [--metric METRIC] [--cookie COOKIE]
                   [--file FILE]
                   {init,query,interface,flow_mon,flow_entry,flow_total,msd,dump,xterm}
                   [{start,stop}]

    Install monitor features or get monitor data from the SONATA platform/emulator.
    

positional arguments:
  {init,query,interface,flow_mon,flow_entry,flow_total,msd,dump,xterm}
                        Monitoring feature to be executed:
                                 interface: export interface metric (tx/rx bytes/packets)
                                 flow_entry : (un)set the flow entry
                                 flow_mon : export flow_entry metric (tx/rx bytes/packets)
                                 flow_total : flow_entry + flow_mon
                                 init : start/stop the monitoring framework
                                 msd :  start/stop monitoring metrics from the msd (monitoring descriptor file)
                                 dump: start tcpdump for specified interface (save as .pcap)
                                 xterm: start an x-terminal for specific vnf(s)
                                 
  {start,stop}          Action for interface, flow_mon, flow_entry, flow_total:
                                  start: install the flowentry and/or export the metric
                                  stop: delete the flowentry and/or stop exporting the metric
                                  Action for init:
                                  start: start the monitoring framework (cAdvisor, Prometheus DB + Pushgateway)
                                  stop: stop the monitoring framework
                                  Action for msd:
                                  start: start exporting the monitoring metrics from the msd
                                  stop: stop exporting the monitoring metrics from the msd
                                  

optional arguments:
  -h, --help            show this help message and exit
  --vnf_names [VNF_NAMES [VNF_NAMES ...]], -n [VNF_NAMES [VNF_NAMES ...]]
                        vnf names to open an xterm for
  --vim VIM, -v VIM     VIM where the command should be executed (emu/sp)
  --vnf_name VNF_NAME, -vnf VNF_NAME
                        vnf name:interface to be monitored
  --datacenter DATACENTER, -d DATACENTER
                        Data center where the vnf is deployed
  --image IMAGE, -i IMAGE
                        Name of container image to be used e.g. 'ubuntu:trusty'
  --dcmd DOCKER_COMMAND, -cmd DOCKER_COMMAND
                        Startup command of the container e.g. './start.sh'
  --net NETWORK         Network properties of a compute instance e.g.           '(id=input,ip=10.0.10.3/24),(id=output,ip=10.0.10.4/24)' for multiple interfaces.
  --query QUERY, -q QUERY
                        prometheus query
  --input INPUT, -in INPUT
                        input interface of the vnf to profile
  --output OUTPUT, -out OUTPUT
                        output interface of the vnf to profile
  --source SOURCE, -src SOURCE
                        vnf name:interface of the source of the chain
  --destination DESTINATION, -dst DESTINATION
                        vnf name:interface of the destination of the chain
  --weight WEIGHT, -w WEIGHT
                        weight edge attribute to calculate the path
  --match MATCH, -ma MATCH
                        string to specify how to match the monitored flow
  --priority PRIORITY, -p PRIORITY
                        priority of the flow match entry, installed to get counter metrics for the monitored flow.
  --bidirectional, -b   add/remove the flow entries from src to dst and back
  --metric METRIC, -me METRIC
                        tx_bytes, rx_bytes, tx_packets, rx_packets
  --cookie COOKIE, -c COOKIE
                        integer value to identify this flow monitor rule
  --file FILE, -f FILE  service descriptor file describing monitoring rules or pcap dump file

General usage:
    son-monitor init
    son-monitor msd -f msd_example.yml
    son-monitor init stop
    son-monitor xterm -n vnf1 vnf2

Specialized usage:
    son-monitor flow_total start -src vnf1  -dst vnf2  -ma "dl_type=0x0800,nw_proto=17,udp_dst=5001"  -b -c 11 -me tx_bytes
    son-monitor query --vim emu -d datacenter1 -vnf vnf1 -q 'sum(rate(container_cpu_usage_seconds_total{id="/docker/<uuid>"}[10s]))'

```

This command starts all the related docker files (cAdvisor, Prometheus DB, PushGateway and son-emu (experimental))
```
son-monitor init
```

After a service has been deployed on the SDK emulator (son-emu), son-monitor can be used.
Son-monitor uses the son-emu rest api and Prometheus.

*Example1*: Expose the tx_packets metric from son-emu network switch-port where vnf1 (default 1st interface) is connected.
The metric is exposed to the Prometheus DB.
```
son-monitor son-monitor interface start -vnf vnf1 -me tx_packets
```

*Example2*: Install a flow_entry in son-emu, monitor the tx_bytes on that flow_entry.
The metric is exposed to the Prometheus DB.
```
son-monitor flow_total start -src vnf1  -dst vnf2  -ma "dl_type=0x0800,nw_proto=17,udp_dst=5001"  -b -c 11 -me tx_bytes
```

*Example3*:  Send a query to the prometheus DB to retrieve the earlier exposed metrics, or default metric exposed by cAdvisor.
The Prometheus query language can be used.
```
son-monitor query --vim emu -d datacenter1 -vnf vnf1 -q 'sum(rate(container_cpu_usage_seconds_total{id="/docker/<uuid>"}[10s]))'
```

## License
The son-cli is published under Apache 2.0 license. Please see the LICENSE file for more details.

#### Lead Developers
The following lead developers are responsible for this repository and have admin rights. They can, for example, merge pull requests.

* Tiago Batista (https://github.com/tsbatista)
* Wouter Tavernier (https://github.com/wtaverni)
* Luís Conceição (https://github.com/lconceicao)

#### Feedback-Chanel
* You may use the mailing list [sonata-dev@lists.atosresearch.eu](mailto:sonata-dev@lists.atosresearch.eu)
* [GitHub issues](https://github.com/sonata-nfv/son-cli/issues)

