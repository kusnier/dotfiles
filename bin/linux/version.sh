#!/bin/bash
xmllint --xpath '/*[local-name()="project"]/*[local-name()="version"]/text()' pom.xml