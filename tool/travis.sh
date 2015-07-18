#!/bin/bash -e

dartanalyzer --fatal-warnings {lib,example}/*.dart

pub run test
