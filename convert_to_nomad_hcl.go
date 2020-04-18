package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"os"
	"strconv"
	"strings"

	"github.com/hashicorp/hcl"
	"github.com/hashicorp/hcl/hcl/printer"
	yaml "gopkg.in/yaml.v2"
)

// DockerComposeService represents a service in componse-file
type DockerComposeService struct {
	Image  string `json:"image"`
	Deploy struct {
		Resources struct {
			Limits struct {
				Cpus   string `json:"cpus"`
				Memory string `json:"memory"`
			} `json:"limits"`
		} `json:"resources"`
	} `json:"deploy"`
	Healthcheck struct {
		Test        []string `json:"test"`
		Interval    string   `json:"interval"`
		Timeout     string   `json:"timeout"`
		Retries     int      `json:"retries"`
		StartPeriod string   `json:"start_period"`
	} `json:"healthcheck"`
	Environment []string `json:"environment"`
}

// DockerComposeFileContent represents the compose-file
type DockerComposeFileContent struct {
	Version  string
	Services map[string]DockerComposeService
}

func main() {
	dat, err := ioutil.ReadFile("./docker-compose.yml")
	if err != nil {
		panic(err)
	}
	var dockerFileContent = DockerComposeFileContent{}
	yaml.Unmarshal(dat, &dockerFileContent)
	for name, service := range dockerFileContent.Services {
		job, err := convertToNomadJob(name, service)
		if err != nil {
			panic(err)
		}
		err = printJob(name, map[string]map[string]Job{"job": map[string]Job{name: job}})
		if err != nil {
			panic(err)
		}
	}
}

func printJob(name string, job map[string]map[string]Job) error {
	data, err := json.Marshal(job)
	if err != nil {
		return fmt.Errorf("unable to marshal %v", err)
	}

	ast, err := hcl.ParseBytes(data)
	if err != nil {
		return fmt.Errorf("unable to parse as hcl %v", err)
	}

	fo, err := os.Create(fmt.Sprintf("%s.nomad", name))
	if err != nil {
		return err
	}

	err = printer.Fprint(fo, ast.Node)
	if err != nil {
		return fmt.Errorf("unable to write as hcl %v", err)
	}
	return nil
}

// Group represents nomad group
type Group struct {
	Count int             `json:"count"`
	Task  map[string]Task `json:"task"`
}

// Config represents nomad task config
type Config struct {
	Args    []string  `json:"args,omitempty"`
	Image   string    `json:"image"`
	PortMap []PortMap `json:"port_map,omitempty"`
}

// PortMap represents nomad task port map
type PortMap struct {
	ServicePort int `json:"service_port"`
}

// Service represents nomad task service
type Service struct {
	Name string   `json:"name,omitempty"`
	Port string   `json:"port,omitempty"`
	Tags []string `json:"tags,omitempty"`
}

// Task represents nomad task
type Task struct {
	Config    []Config `json:"config"`
	Driver    string   `json:"driver"`
	Resources []struct {
		CPU     int `json:"cpu"`
		Memory  int `json:"memory"`
		Network []struct {
			Mbits int `json:"mbits"`
			Port  []struct {
				ServicePort []struct {
				} `json:"service_port"`
			} `json:"port"`
		} `json:"network"`
	} `json:"resources,omitempty"`
	Service []Service         `json:"service,omitempty"`
	Env     map[string]string `json:"env,omitempty"`
}

// Job represents nomad job
type Job struct {
	Datacenters []string         `json:"datacenters"`
	Type        string           `json:"type"`
	Group       map[string]Group `json:"group"`
}

func convertToNomadJob(name string, service DockerComposeService) (Job, error) {
	portMaps, err := getPortMaps(service.Environment)
	if err != nil {
		return Job{}, err
	}
	if err != nil {
		return Job{}, err
	}
	services := []Service{}
	for _, portMap := range portMaps {
		services = append(services, Service{Name: name, Port: strconv.Itoa(portMap.ServicePort)})
	}

	envs := environmentsAsMap(service.Environment)
	task := Task{
		Driver: "docker",
		Config: []Config{
			{
				Image:   service.Image,
				PortMap: portMaps,
			},
		},
		Service: services,
		Env:     envs,
	}
	group := Group{Count: 1, Task: map[string]Task{name: task}}
	job := Job{Datacenters: []string{"dc1"}, Type: "service", Group: map[string]Group{name: group}}

	return job, nil
}

func environmentsAsMap(envs []string) map[string]string {
	acc := map[string]string{}
	for _, env := range envs {
		temp := strings.Split(env, "=")
		acc[temp[0]] = temp[1]
	}
	return acc
}

func getPortMaps(configs []string) ([]PortMap, error) {
	for _, config := range configs {
		if strings.HasPrefix(config, "PORT=") {
			servicePort, err := strconv.Atoi(strings.TrimPrefix(config, "PORT="))
			if err != nil {
				return nil, err
			}
			return []PortMap{{ServicePort: servicePort}}, nil
		}
	}
	return []PortMap{}, nil
}
