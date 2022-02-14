#!/bin/bash
#
# Version    | 22.03a
# Email      | support@pfelk.com
# Website    | https://pfelk.com
#
###################################################################################################################################################################################################
#                                                                                                                                                                                                 #
#                                                                                           Color Codes                                                                                           #
#                                                                                                                                                                                                 #
###################################################################################################################################################################################################
#
RESET='\033[0m'
WHITE_R='\033[39m'
RED='\033[1;31m' # Light Red.
GREEN='\033[1;32m' # Light Green.
#
header() {
  clear
  clear
  echo -e "${GREEN}#####################################################################################################${RESET}\\n"
}

header_red() {
  clear
  clear
  echo -e "${RED}#####################################################################################################${RESET}\\n"
}
#
# Check for root (sudo)
if [[ "$EUID" -ne 0 ]]; then
  header_red
  echo -e "${WHITE_R}#${RESET} The script need to be run as root...\\n\\n"
  echo -e "${WHITE_R}#${RESET} For Ubuntu based systems run the command below to login as root"
  echo -e "${GREEN}#${RESET} sudo -i\\n"
  echo -e "${WHITE_R}#${RESET} For Debian based systems run the command below to login as root"
  echo -e "${GREEN}#${RESET} su\\n\\n"
  exit 1
fi
#
###################################################################################################################################################################################################
#                                                                                                                                                                                                 #
#                                                                                   pfELK - Install Required Templates                                                                            #
#                                                                                                                                                                                                 #
###################################################################################################################################################################################################
curl -X PUT "localhost:9200/_component_template/pfelk-settings?pretty" -H 'Content-Type: application/json' -d'
{
  "template": {
    "settings": {
      "index": {
        "mapping": {
          "total_fields": {
            "limit": "10000"
          }
        },
        "refresh_interval": "5s"
      }
    },
    "mappings": {
      "_meta": {
        "version": "8.0.0-dev",
        "managed": true,
        "description": "pfELK ecs mappings"
      },
      "dynamic_templates": [
        {
          "strings_as_keyword": {
            "match_mapping_type": "string",
            "mapping": {
              "ignore_above": 1024,
              "type": "keyword"
            }
          }
        }
      ],
      "date_detection": false,
      "properties": {
        "@timestamp": {
          "type": "date"
        },
        "agent": {
          "properties": {
            "build": {
              "properties": {
                "original": {
                  "type": "keyword",
                  "ignore_above": 1024
                }
              }
            },
            "ephemeral_id": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "id": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "name": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "type": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "version": {
              "type": "keyword",
              "ignore_above": 1024
            }
          }
        },
        "client": {
          "properties": {
            "address": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "as": {
              "properties": {
                "number": {
                  "type": "long"
                },
                "organization": {
                  "properties": {
                    "name": {
                      "type": "keyword",
                      "ignore_above": 1024,
                      "fields": {
                        "text": {
                          "type": "match_only_text"
                        }
                      }
                    }
                  }
                }
              }
            },
            "bytes": {
              "type": "long"
            },
            "domain": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "geo": {
              "properties": {
                "city_name": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "continent_code": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "continent_name": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "country_iso_code": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "country_name": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "location": {
                  "type": "geo_point"
                },
                "name": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "postal_code": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "region_iso_code": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "region_name": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "timezone": {
                  "type": "keyword",
                  "ignore_above": 1024
                }
              }
            },
            "ip": {
              "type": "ip"
            },
            "mac": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "nat": {
              "properties": {
                "ip": {
                  "type": "ip"
                },
                "port": {
                  "type": "long"
                }
              }
            },
            "packets": {
              "type": "long"
            },
            "port": {
              "type": "long"
            },
            "registered_domain": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "subdomain": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "top_level_domain": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "user": {
              "properties": {
                "domain": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "email": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "full_name": {
                  "type": "keyword",
                  "ignore_above": 1024,
                  "fields": {
                    "text": {
                      "type": "match_only_text"
                    }
                  }
                },
                "group": {
                  "properties": {
                    "domain": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "id": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "name": {
                      "type": "keyword",
                      "ignore_above": 1024
                    }
                  }
                },
                "hash": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "id": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "name": {
                  "type": "keyword",
                  "ignore_above": 1024,
                  "fields": {
                    "text": {
                      "type": "match_only_text"
                    }
                  }
                },
                "roles": {
                  "type": "keyword",
                  "ignore_above": 1024
                }
              }
            }
          }
        },
        "cloud": {
          "properties": {
            "account": {
              "properties": {
                "id": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "name": {
                  "type": "keyword",
                  "ignore_above": 1024
                }
              }
            },
            "availability_zone": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "instance": {
              "properties": {
                "id": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "name": {
                  "type": "keyword",
                  "ignore_above": 1024
                }
              }
            },
            "machine": {
              "properties": {
                "type": {
                  "type": "keyword",
                  "ignore_above": 1024
                }
              }
            },
            "origin": {
              "properties": {
                "account": {
                  "properties": {
                    "id": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "name": {
                      "type": "keyword",
                      "ignore_above": 1024
                    }
                  }
                },
                "availability_zone": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "instance": {
                  "properties": {
                    "id": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "name": {
                      "type": "keyword",
                      "ignore_above": 1024
                    }
                  }
                },
                "machine": {
                  "properties": {
                    "type": {
                      "type": "keyword",
                      "ignore_above": 1024
                    }
                  }
                },
                "project": {
                  "properties": {
                    "id": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "name": {
                      "type": "keyword",
                      "ignore_above": 1024
                    }
                  }
                },
                "provider": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "region": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "service": {
                  "properties": {
                    "name": {
                      "type": "keyword",
                      "ignore_above": 1024
                    }
                  }
                }
              }
            },
            "project": {
              "properties": {
                "id": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "name": {
                  "type": "keyword",
                  "ignore_above": 1024
                }
              }
            },
            "provider": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "region": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "service": {
              "properties": {
                "name": {
                  "type": "keyword",
                  "ignore_above": 1024
                }
              }
            },
            "target": {
              "properties": {
                "account": {
                  "properties": {
                    "id": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "name": {
                      "type": "keyword",
                      "ignore_above": 1024
                    }
                  }
                },
                "availability_zone": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "instance": {
                  "properties": {
                    "id": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "name": {
                      "type": "keyword",
                      "ignore_above": 1024
                    }
                  }
                },
                "machine": {
                  "properties": {
                    "type": {
                      "type": "keyword",
                      "ignore_above": 1024
                    }
                  }
                },
                "project": {
                  "properties": {
                    "id": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "name": {
                      "type": "keyword",
                      "ignore_above": 1024
                    }
                  }
                },
                "provider": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "region": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "service": {
                  "properties": {
                    "name": {
                      "type": "keyword",
                      "ignore_above": 1024
                    }
                  }
                }
              }
            }
          }
        },
        "container": {
          "properties": {
            "id": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "image": {
              "properties": {
                "name": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "tag": {
                  "type": "keyword",
                  "ignore_above": 1024
                }
              }
            },
            "labels": {
              "type": "object"
            },
            "name": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "runtime": {
              "type": "keyword",
              "ignore_above": 1024
            }
          }
        },
        "data_stream": {
          "properties": {
            "dataset": {
              "type": "constant_keyword"
            },
            "namespace": {
              "type": "constant_keyword"
            },
            "type": {
              "type": "constant_keyword"
            }
          }
        },
        "destination": {
          "properties": {
            "address": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "as": {
              "properties": {
                "number": {
                  "type": "long"
                },
                "organization": {
                  "properties": {
                    "name": {
                      "type": "keyword",
                      "ignore_above": 1024,
                      "fields": {
                        "text": {
                          "type": "match_only_text"
                        }
                      }
                    }
                  }
                }
              }
            },
            "bytes": {
              "type": "long"
            },
            "domain": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "geo": {
              "properties": {
                "city_name": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "continent_code": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "continent_name": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "country_iso_code": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "country_name": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "location": {
                  "type": "geo_point"
                },
                "name": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "postal_code": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "region_iso_code": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "region_name": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "timezone": {
                  "type": "keyword",
                  "ignore_above": 1024
                }
              }
            },
            "ip": {
              "type": "ip"
            },
            "mac": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "nat": {
              "properties": {
                "ip": {
                  "type": "ip"
                },
                "port": {
                  "type": "long"
                }
              }
            },
            "packets": {
              "type": "long"
            },
            "port": {
              "type": "long"
            },
            "registered_domain": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "subdomain": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "top_level_domain": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "user": {
              "properties": {
                "domain": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "email": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "full_name": {
                  "type": "keyword",
                  "ignore_above": 1024,
                  "fields": {
                    "text": {
                      "type": "match_only_text"
                    }
                  }
                },
                "group": {
                  "properties": {
                    "domain": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "id": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "name": {
                      "type": "keyword",
                      "ignore_above": 1024
                    }
                  }
                },
                "hash": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "id": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "name": {
                  "type": "keyword",
                  "ignore_above": 1024,
                  "fields": {
                    "text": {
                      "type": "match_only_text"
                    }
                  }
                },
                "roles": {
                  "type": "keyword",
                  "ignore_above": 1024
                }
              }
            }
          }
        },
        "dll": {
          "properties": {
            "code_signature": {
              "properties": {
                "digest_algorithm": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "exists": {
                  "type": "boolean"
                },
                "signing_id": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "status": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "subject_name": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "team_id": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "timestamp": {
                  "type": "date"
                },
                "trusted": {
                  "type": "boolean"
                },
                "valid": {
                  "type": "boolean"
                }
              }
            },
            "hash": {
              "properties": {
                "md5": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "sha1": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "sha256": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "sha512": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "ssdeep": {
                  "type": "keyword",
                  "ignore_above": 1024
                }
              }
            },
            "name": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "path": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "pe": {
              "properties": {
                "architecture": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "company": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "description": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "file_version": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "imphash": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "original_file_name": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "product": {
                  "type": "keyword",
                  "ignore_above": 1024
                }
              }
            }
          }
        },
        "dns": {
          "properties": {
            "answers": {
              "properties": {
                "class": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "data": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "name": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "ttl": {
                  "type": "long"
                },
                "type": {
                  "type": "keyword",
                  "ignore_above": 1024
                }
              }
            },
            "header_flags": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "id": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "op_code": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "question": {
              "properties": {
                "class": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "name": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "registered_domain": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "subdomain": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "top_level_domain": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "type": {
                  "type": "keyword",
                  "ignore_above": 1024
                }
              }
            },
            "resolved_ip": {
              "type": "ip"
            },
            "response_code": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "type": {
              "type": "keyword",
              "ignore_above": 1024
            }
          }
        },
        "ecs": {
          "properties": {
            "version": {
              "type": "keyword",
              "ignore_above": 1024
            }
          }
        },
        "error": {
          "properties": {
            "code": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "id": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "message": {
              "type": "match_only_text"
            },
            "stack_trace": {
              "type": "wildcard",
              "fields": {
                "text": {
                  "type": "match_only_text"
                }
              }
            },
            "type": {
              "type": "keyword",
              "ignore_above": 1024
            }
          }
        },
        "event": {
          "properties": {
            "action": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "agent_id_status": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "category": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "code": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "created": {
              "type": "date"
            },
            "dataset": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "duration": {
              "type": "long"
            },
            "end": {
              "type": "date"
            },
            "hash": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "id": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "ingested": {
              "type": "date"
            },
            "kind": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "module": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "original": {
              "type": "keyword",
              "index": false,
              "doc_values": false
            },
            "outcome": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "provider": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "reason": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "reference": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "risk_score": {
              "type": "float"
            },
            "risk_score_norm": {
              "type": "float"
            },
            "sequence": {
              "type": "long"
            },
            "severity": {
              "type": "long"
            },
            "start": {
              "type": "date"
            },
            "timezone": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "type": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "url": {
              "type": "keyword",
              "ignore_above": 1024
            }
          }
        },
        "faas": {
          "properties": {
            "coldstart": {
              "type": "boolean"
            },
            "execution": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "trigger": {
              "type": "nested",
              "properties": {
                "request_id": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "type": {
                  "type": "keyword",
                  "ignore_above": 1024
                }
              }
            }
          }
        },
        "file": {
          "properties": {
            "accessed": {
              "type": "date"
            },
            "attributes": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "code_signature": {
              "properties": {
                "digest_algorithm": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "exists": {
                  "type": "boolean"
                },
                "signing_id": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "status": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "subject_name": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "team_id": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "timestamp": {
                  "type": "date"
                },
                "trusted": {
                  "type": "boolean"
                },
                "valid": {
                  "type": "boolean"
                }
              }
            },
            "created": {
              "type": "date"
            },
            "ctime": {
              "type": "date"
            },
            "device": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "directory": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "drive_letter": {
              "type": "keyword",
              "ignore_above": 1
            },
            "elf": {
              "properties": {
                "architecture": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "byte_order": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "cpu_type": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "creation_date": {
                  "type": "date"
                },
                "exports": {
                  "type": "flattened"
                },
                "header": {
                  "properties": {
                    "abi_version": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "class": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "data": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "entrypoint": {
                      "type": "long"
                    },
                    "object_version": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "os_abi": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "type": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "version": {
                      "type": "keyword",
                      "ignore_above": 1024
                    }
                  }
                },
                "imports": {
                  "type": "flattened"
                },
                "sections": {
                  "type": "nested",
                  "properties": {
                    "chi2": {
                      "type": "long"
                    },
                    "entropy": {
                      "type": "long"
                    },
                    "flags": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "name": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "physical_offset": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "physical_size": {
                      "type": "long"
                    },
                    "type": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "virtual_address": {
                      "type": "long"
                    },
                    "virtual_size": {
                      "type": "long"
                    }
                  }
                },
                "segments": {
                  "type": "nested",
                  "properties": {
                    "sections": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "type": {
                      "type": "keyword",
                      "ignore_above": 1024
                    }
                  }
                },
                "shared_libraries": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "telfhash": {
                  "type": "keyword",
                  "ignore_above": 1024
                }
              }
            },
            "extension": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "fork_name": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "gid": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "group": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "hash": {
              "properties": {
                "md5": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "sha1": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "sha256": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "sha512": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "ssdeep": {
                  "type": "keyword",
                  "ignore_above": 1024
                }
              }
            },
            "inode": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "mime_type": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "mode": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "mtime": {
              "type": "date"
            },
            "name": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "owner": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "path": {
              "type": "keyword",
              "ignore_above": 1024,
              "fields": {
                "text": {
                  "type": "match_only_text"
                }
              }
            },
            "pe": {
              "properties": {
                "architecture": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "company": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "description": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "file_version": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "imphash": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "original_file_name": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "product": {
                  "type": "keyword",
                  "ignore_above": 1024
                }
              }
            },
            "size": {
              "type": "long"
            },
            "target_path": {
              "type": "keyword",
              "ignore_above": 1024,
              "fields": {
                "text": {
                  "type": "match_only_text"
                }
              }
            },
            "type": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "uid": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "x509": {
              "properties": {
                "alternative_names": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "issuer": {
                  "properties": {
                    "common_name": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "country": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "distinguished_name": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "locality": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "organization": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "organizational_unit": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "state_or_province": {
                      "type": "keyword",
                      "ignore_above": 1024
                    }
                  }
                },
                "not_after": {
                  "type": "date"
                },
                "not_before": {
                  "type": "date"
                },
                "public_key_algorithm": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "public_key_curve": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "public_key_exponent": {
                  "type": "long",
                  "index": false,
                  "doc_values": false
                },
                "public_key_size": {
                  "type": "long"
                },
                "serial_number": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "signature_algorithm": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "subject": {
                  "properties": {
                    "common_name": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "country": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "distinguished_name": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "locality": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "organization": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "organizational_unit": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "state_or_province": {
                      "type": "keyword",
                      "ignore_above": 1024
                    }
                  }
                },
                "version_number": {
                  "type": "keyword",
                  "ignore_above": 1024
                }
              }
            }
          }
        },
        "group": {
          "properties": {
            "domain": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "id": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "name": {
              "type": "keyword",
              "ignore_above": 1024
            }
          }
        },
        "host": {
          "properties": {
            "architecture": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "cpu": {
              "properties": {
                "usage": {
                  "type": "scaled_float",
                  "scaling_factor": 1000
                }
              }
            },
            "disk": {
              "properties": {
                "read": {
                  "properties": {
                    "bytes": {
                      "type": "long"
                    }
                  }
                },
                "write": {
                  "properties": {
                    "bytes": {
                      "type": "long"
                    }
                  }
                }
              }
            },
            "domain": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "geo": {
              "properties": {
                "city_name": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "continent_code": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "continent_name": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "country_iso_code": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "country_name": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "location": {
                  "type": "geo_point"
                },
                "name": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "postal_code": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "region_iso_code": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "region_name": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "timezone": {
                  "type": "keyword",
                  "ignore_above": 1024
                }
              }
            },
            "hostname": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "id": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "ip": {
              "type": "ip"
            },
            "mac": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "name": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "network": {
              "properties": {
                "egress": {
                  "properties": {
                    "bytes": {
                      "type": "long"
                    },
                    "packets": {
                      "type": "long"
                    }
                  }
                },
                "ingress": {
                  "properties": {
                    "bytes": {
                      "type": "long"
                    },
                    "packets": {
                      "type": "long"
                    }
                  }
                }
              }
            },
            "os": {
              "properties": {
                "family": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "full": {
                  "type": "keyword",
                  "ignore_above": 1024,
                  "fields": {
                    "text": {
                      "type": "match_only_text"
                    }
                  }
                },
                "kernel": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "name": {
                  "type": "keyword",
                  "ignore_above": 1024,
                  "fields": {
                    "text": {
                      "type": "match_only_text"
                    }
                  }
                },
                "platform": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "type": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "version": {
                  "type": "keyword",
                  "ignore_above": 1024
                }
              }
            },
            "type": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "uptime": {
              "type": "long"
            }
          }
        },
        "http": {
          "properties": {
            "request": {
              "properties": {
                "body": {
                  "properties": {
                    "bytes": {
                      "type": "long"
                    },
                    "content": {
                      "type": "wildcard",
                      "fields": {
                        "text": {
                          "type": "match_only_text"
                        }
                      }
                    }
                  }
                },
                "bytes": {
                  "type": "long"
                },
                "id": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "method": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "mime_type": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "referrer": {
                  "type": "keyword",
                  "ignore_above": 1024
                }
              }
            },
            "response": {
              "properties": {
                "body": {
                  "properties": {
                    "bytes": {
                      "type": "long"
                    },
                    "content": {
                      "type": "wildcard",
                      "fields": {
                        "text": {
                          "type": "match_only_text"
                        }
                      }
                    }
                  }
                },
                "bytes": {
                  "type": "long"
                },
                "mime_type": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "status_code": {
                  "type": "long"
                }
              }
            },
            "version": {
              "type": "keyword",
              "ignore_above": 1024
            }
          }
        },
        "labels": {
          "type": "object"
        },
        "log": {
          "properties": {
            "file": {
              "properties": {
                "path": {
                  "type": "keyword",
                  "ignore_above": 1024
                }
              }
            },
            "level": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "logger": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "origin": {
              "properties": {
                "file": {
                  "properties": {
                    "line": {
                      "type": "long"
                    },
                    "name": {
                      "type": "keyword",
                      "ignore_above": 1024
                    }
                  }
                },
                "function": {
                  "type": "keyword",
                  "ignore_above": 1024
                }
              }
            },
            "syslog": {
              "properties": {
                "facility": {
                  "properties": {
                    "code": {
                      "type": "long"
                    },
                    "name": {
                      "type": "keyword",
                      "ignore_above": 1024
                    }
                  }
                },
                "priority": {
                  "type": "long"
                },
                "severity": {
                  "properties": {
                    "code": {
                      "type": "long"
                    },
                    "name": {
                      "type": "keyword",
                      "ignore_above": 1024
                    }
                  }
                }
              }
            }
          }
        },
        "message": {
          "type": "match_only_text"
        },
        "network": {
          "properties": {
            "application": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "bytes": {
              "type": "long"
            },
            "community_id": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "direction": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "forwarded_ip": {
              "type": "ip"
            },
            "iana_number": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "inner": {
              "properties": {
                "vlan": {
                  "properties": {
                    "id": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "name": {
                      "type": "keyword",
                      "ignore_above": 1024
                    }
                  }
                }
              }
            },
            "name": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "packets": {
              "type": "long"
            },
            "protocol": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "transport": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "type": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "vlan": {
              "properties": {
                "id": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "name": {
                  "type": "keyword",
                  "ignore_above": 1024
                }
              }
            }
          }
        },
        "observer": {
          "properties": {
            "egress": {
              "properties": {
                "interface": {
                  "properties": {
                    "alias": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "id": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "name": {
                      "type": "keyword",
                      "ignore_above": 1024
                    }
                  }
                },
                "vlan": {
                  "properties": {
                    "id": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "name": {
                      "type": "keyword",
                      "ignore_above": 1024
                    }
                  }
                },
                "zone": {
                  "type": "keyword",
                  "ignore_above": 1024
                }
              }
            },
            "geo": {
              "properties": {
                "city_name": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "continent_code": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "continent_name": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "country_iso_code": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "country_name": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "location": {
                  "type": "geo_point"
                },
                "name": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "postal_code": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "region_iso_code": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "region_name": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "timezone": {
                  "type": "keyword",
                  "ignore_above": 1024
                }
              }
            },
            "hostname": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "ingress": {
              "properties": {
                "interface": {
                  "properties": {
                    "alias": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "id": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "name": {
                      "type": "keyword",
                      "ignore_above": 1024
                    }
                  }
                },
                "vlan": {
                  "properties": {
                    "id": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "name": {
                      "type": "keyword",
                      "ignore_above": 1024
                    }
                  }
                },
                "zone": {
                  "type": "keyword",
                  "ignore_above": 1024
                }
              }
            },
            "ip": {
              "type": "ip"
            },
            "mac": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "name": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "os": {
              "properties": {
                "family": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "full": {
                  "type": "keyword",
                  "ignore_above": 1024,
                  "fields": {
                    "text": {
                      "type": "match_only_text"
                    }
                  }
                },
                "kernel": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "name": {
                  "type": "keyword",
                  "ignore_above": 1024,
                  "fields": {
                    "text": {
                      "type": "match_only_text"
                    }
                  }
                },
                "platform": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "type": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "version": {
                  "type": "keyword",
                  "ignore_above": 1024
                }
              }
            },
            "product": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "serial_number": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "type": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "vendor": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "version": {
              "type": "keyword",
              "ignore_above": 1024
            }
          }
        },
        "orchestrator": {
          "properties": {
            "api_version": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "cluster": {
              "properties": {
                "name": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "url": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "version": {
                  "type": "keyword",
                  "ignore_above": 1024
                }
              }
            },
            "namespace": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "organization": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "resource": {
              "properties": {
                "name": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "type": {
                  "type": "keyword",
                  "ignore_above": 1024
                }
              }
            },
            "type": {
              "type": "keyword",
              "ignore_above": 1024
            }
          }
        },
        "organization": {
          "properties": {
            "id": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "name": {
              "type": "keyword",
              "ignore_above": 1024,
              "fields": {
                "text": {
                  "type": "match_only_text"
                }
              }
            }
          }
        },
        "package": {
          "properties": {
            "architecture": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "build_version": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "checksum": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "description": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "install_scope": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "installed": {
              "type": "date"
            },
            "license": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "name": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "path": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "reference": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "size": {
              "type": "long"
            },
            "type": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "version": {
              "type": "keyword",
              "ignore_above": 1024
            }
          }
        },
        "process": {
          "properties": {
            "args": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "args_count": {
              "type": "long"
            },
            "code_signature": {
              "properties": {
                "digest_algorithm": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "exists": {
                  "type": "boolean"
                },
                "signing_id": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "status": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "subject_name": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "team_id": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "timestamp": {
                  "type": "date"
                },
                "trusted": {
                  "type": "boolean"
                },
                "valid": {
                  "type": "boolean"
                }
              }
            },
            "command_line": {
              "type": "wildcard",
              "fields": {
                "text": {
                  "type": "match_only_text"
                }
              }
            },
            "elf": {
              "properties": {
                "architecture": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "byte_order": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "cpu_type": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "creation_date": {
                  "type": "date"
                },
                "exports": {
                  "type": "flattened"
                },
                "header": {
                  "properties": {
                    "abi_version": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "class": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "data": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "entrypoint": {
                      "type": "long"
                    },
                    "object_version": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "os_abi": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "type": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "version": {
                      "type": "keyword",
                      "ignore_above": 1024
                    }
                  }
                },
                "imports": {
                  "type": "flattened"
                },
                "sections": {
                  "type": "nested",
                  "properties": {
                    "chi2": {
                      "type": "long"
                    },
                    "entropy": {
                      "type": "long"
                    },
                    "flags": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "name": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "physical_offset": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "physical_size": {
                      "type": "long"
                    },
                    "type": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "virtual_address": {
                      "type": "long"
                    },
                    "virtual_size": {
                      "type": "long"
                    }
                  }
                },
                "segments": {
                  "type": "nested",
                  "properties": {
                    "sections": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "type": {
                      "type": "keyword",
                      "ignore_above": 1024
                    }
                  }
                },
                "shared_libraries": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "telfhash": {
                  "type": "keyword",
                  "ignore_above": 1024
                }
              }
            },
            "end": {
              "type": "date"
            },
            "entity_id": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "executable": {
              "type": "keyword",
              "ignore_above": 1024,
              "fields": {
                "text": {
                  "type": "match_only_text"
                }
              }
            },
            "exit_code": {
              "type": "long"
            },
            "hash": {
              "properties": {
                "md5": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "sha1": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "sha256": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "sha512": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "ssdeep": {
                  "type": "keyword",
                  "ignore_above": 1024
                }
              }
            },
            "name": {
              "type": "keyword",
              "ignore_above": 1024,
              "fields": {
                "text": {
                  "type": "match_only_text"
                }
              }
            },
            "parent": {
              "properties": {
                "args": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "args_count": {
                  "type": "long"
                },
                "code_signature": {
                  "properties": {
                    "digest_algorithm": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "exists": {
                      "type": "boolean"
                    },
                    "signing_id": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "status": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "subject_name": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "team_id": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "timestamp": {
                      "type": "date"
                    },
                    "trusted": {
                      "type": "boolean"
                    },
                    "valid": {
                      "type": "boolean"
                    }
                  }
                },
                "command_line": {
                  "type": "wildcard",
                  "fields": {
                    "text": {
                      "type": "match_only_text"
                    }
                  }
                },
                "elf": {
                  "properties": {
                    "architecture": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "byte_order": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "cpu_type": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "creation_date": {
                      "type": "date"
                    },
                    "exports": {
                      "type": "flattened"
                    },
                    "header": {
                      "properties": {
                        "abi_version": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "class": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "data": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "entrypoint": {
                          "type": "long"
                        },
                        "object_version": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "os_abi": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "type": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "version": {
                          "type": "keyword",
                          "ignore_above": 1024
                        }
                      }
                    },
                    "imports": {
                      "type": "flattened"
                    },
                    "sections": {
                      "type": "nested",
                      "properties": {
                        "chi2": {
                          "type": "long"
                        },
                        "entropy": {
                          "type": "long"
                        },
                        "flags": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "name": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "physical_offset": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "physical_size": {
                          "type": "long"
                        },
                        "type": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "virtual_address": {
                          "type": "long"
                        },
                        "virtual_size": {
                          "type": "long"
                        }
                      }
                    },
                    "segments": {
                      "type": "nested",
                      "properties": {
                        "sections": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "type": {
                          "type": "keyword",
                          "ignore_above": 1024
                        }
                      }
                    },
                    "shared_libraries": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "telfhash": {
                      "type": "keyword",
                      "ignore_above": 1024
                    }
                  }
                },
                "end": {
                  "type": "date"
                },
                "entity_id": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "executable": {
                  "type": "keyword",
                  "ignore_above": 1024,
                  "fields": {
                    "text": {
                      "type": "match_only_text"
                    }
                  }
                },
                "exit_code": {
                  "type": "long"
                },
                "hash": {
                  "properties": {
                    "md5": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "sha1": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "sha256": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "sha512": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "ssdeep": {
                      "type": "keyword",
                      "ignore_above": 1024
                    }
                  }
                },
                "name": {
                  "type": "keyword",
                  "ignore_above": 1024,
                  "fields": {
                    "text": {
                      "type": "match_only_text"
                    }
                  }
                },
                "pe": {
                  "properties": {
                    "architecture": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "company": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "description": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "file_version": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "imphash": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "original_file_name": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "product": {
                      "type": "keyword",
                      "ignore_above": 1024
                    }
                  }
                },
                "pgid": {
                  "type": "long"
                },
                "pid": {
                  "type": "long"
                },
                "start": {
                  "type": "date"
                },
                "thread": {
                  "properties": {
                    "id": {
                      "type": "long"
                    },
                    "name": {
                      "type": "keyword",
                      "ignore_above": 1024
                    }
                  }
                },
                "title": {
                  "type": "keyword",
                  "ignore_above": 1024,
                  "fields": {
                    "text": {
                      "type": "match_only_text"
                    }
                  }
                },
                "uptime": {
                  "type": "long"
                },
                "working_directory": {
                  "type": "keyword",
                  "ignore_above": 1024,
                  "fields": {
                    "text": {
                      "type": "match_only_text"
                    }
                  }
                }
              }
            },
            "pe": {
              "properties": {
                "architecture": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "company": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "description": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "file_version": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "imphash": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "original_file_name": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "product": {
                  "type": "keyword",
                  "ignore_above": 1024
                }
              }
            },
            "pgid": {
              "type": "long"
            },
            "pid": {
              "type": "long"
            },
            "start": {
              "type": "date"
            },
            "thread": {
              "properties": {
                "id": {
                  "type": "long"
                },
                "name": {
                  "type": "keyword",
                  "ignore_above": 1024
                }
              }
            },
            "title": {
              "type": "keyword",
              "ignore_above": 1024,
              "fields": {
                "text": {
                  "type": "match_only_text"
                }
              }
            },
            "uptime": {
              "type": "long"
            },
            "working_directory": {
              "type": "keyword",
              "ignore_above": 1024,
              "fields": {
                "text": {
                  "type": "match_only_text"
                }
              }
            }
          }
        },
        "registry": {
          "properties": {
            "data": {
              "properties": {
                "bytes": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "strings": {
                  "type": "wildcard"
                },
                "type": {
                  "type": "keyword",
                  "ignore_above": 1024
                }
              }
            },
            "hive": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "key": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "path": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "value": {
              "type": "keyword",
              "ignore_above": 1024
            }
          }
        },
        "related": {
          "properties": {
            "hash": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "hosts": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "ip": {
              "type": "ip"
            },
            "user": {
              "type": "keyword",
              "ignore_above": 1024
            }
          }
        },
        "rule": {
          "properties": {
            "author": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "category": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "description": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "id": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "license": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "name": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "reference": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "ruleset": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "uuid": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "version": {
              "type": "keyword",
              "ignore_above": 1024
            }
          }
        },
        "server": {
          "properties": {
            "address": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "as": {
              "properties": {
                "number": {
                  "type": "long"
                },
                "organization": {
                  "properties": {
                    "name": {
                      "type": "keyword",
                      "ignore_above": 1024,
                      "fields": {
                        "text": {
                          "type": "match_only_text"
                        }
                      }
                    }
                  }
                }
              }
            },
            "bytes": {
              "type": "long"
            },
            "domain": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "geo": {
              "properties": {
                "city_name": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "continent_code": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "continent_name": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "country_iso_code": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "country_name": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "location": {
                  "type": "geo_point"
                },
                "name": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "postal_code": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "region_iso_code": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "region_name": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "timezone": {
                  "type": "keyword",
                  "ignore_above": 1024
                }
              }
            },
            "ip": {
              "type": "ip"
            },
            "mac": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "nat": {
              "properties": {
                "ip": {
                  "type": "ip"
                },
                "port": {
                  "type": "long"
                }
              }
            },
            "packets": {
              "type": "long"
            },
            "port": {
              "type": "long"
            },
            "registered_domain": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "subdomain": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "top_level_domain": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "user": {
              "properties": {
                "domain": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "email": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "full_name": {
                  "type": "keyword",
                  "ignore_above": 1024,
                  "fields": {
                    "text": {
                      "type": "match_only_text"
                    }
                  }
                },
                "group": {
                  "properties": {
                    "domain": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "id": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "name": {
                      "type": "keyword",
                      "ignore_above": 1024
                    }
                  }
                },
                "hash": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "id": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "name": {
                  "type": "keyword",
                  "ignore_above": 1024,
                  "fields": {
                    "text": {
                      "type": "match_only_text"
                    }
                  }
                },
                "roles": {
                  "type": "keyword",
                  "ignore_above": 1024
                }
              }
            }
          }
        },
        "service": {
          "properties": {
            "address": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "environment": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "ephemeral_id": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "id": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "name": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "node": {
              "properties": {
                "name": {
                  "type": "keyword",
                  "ignore_above": 1024
                }
              }
            },
            "origin": {
              "properties": {
                "address": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "environment": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "ephemeral_id": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "id": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "name": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "node": {
                  "properties": {
                    "name": {
                      "type": "keyword",
                      "ignore_above": 1024
                    }
                  }
                },
                "state": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "type": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "version": {
                  "type": "keyword",
                  "ignore_above": 1024
                }
              }
            },
            "state": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "target": {
              "properties": {
                "address": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "environment": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "ephemeral_id": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "id": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "name": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "node": {
                  "properties": {
                    "name": {
                      "type": "keyword",
                      "ignore_above": 1024
                    }
                  }
                },
                "state": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "type": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "version": {
                  "type": "keyword",
                  "ignore_above": 1024
                }
              }
            },
            "type": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "version": {
              "type": "keyword",
              "ignore_above": 1024
            }
          }
        },
        "source": {
          "properties": {
            "address": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "as": {
              "properties": {
                "number": {
                  "type": "long"
                },
                "organization": {
                  "properties": {
                    "name": {
                      "type": "keyword",
                      "ignore_above": 1024,
                      "fields": {
                        "text": {
                          "type": "match_only_text"
                        }
                      }
                    }
                  }
                }
              }
            },
            "bytes": {
              "type": "long"
            },
            "domain": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "geo": {
              "properties": {
                "city_name": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "continent_code": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "continent_name": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "country_iso_code": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "country_name": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "location": {
                  "type": "geo_point"
                },
                "name": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "postal_code": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "region_iso_code": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "region_name": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "timezone": {
                  "type": "keyword",
                  "ignore_above": 1024
                }
              }
            },
            "ip": {
              "type": "ip"
            },
            "mac": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "nat": {
              "properties": {
                "ip": {
                  "type": "ip"
                },
                "port": {
                  "type": "long"
                }
              }
            },
            "packets": {
              "type": "long"
            },
            "port": {
              "type": "long"
            },
            "registered_domain": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "subdomain": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "top_level_domain": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "user": {
              "properties": {
                "domain": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "email": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "full_name": {
                  "type": "keyword",
                  "ignore_above": 1024,
                  "fields": {
                    "text": {
                      "type": "match_only_text"
                    }
                  }
                },
                "group": {
                  "properties": {
                    "domain": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "id": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "name": {
                      "type": "keyword",
                      "ignore_above": 1024
                    }
                  }
                },
                "hash": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "id": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "name": {
                  "type": "keyword",
                  "ignore_above": 1024,
                  "fields": {
                    "text": {
                      "type": "match_only_text"
                    }
                  }
                },
                "roles": {
                  "type": "keyword",
                  "ignore_above": 1024
                }
              }
            }
          }
        },
        "span": {
          "properties": {
            "id": {
              "type": "keyword",
              "ignore_above": 1024
            }
          }
        },
        "tags": {
          "type": "keyword",
          "ignore_above": 1024
        },
        "threat": {
          "properties": {
            "enrichments": {
              "type": "nested",
              "properties": {
                "indicator": {
                  "properties": {
                    "as": {
                      "properties": {
                        "number": {
                          "type": "long"
                        },
                        "organization": {
                          "properties": {
                            "name": {
                              "type": "keyword",
                              "ignore_above": 1024,
                              "fields": {
                                "text": {
                                  "type": "match_only_text"
                                }
                              }
                            }
                          }
                        }
                      }
                    },
                    "confidence": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "description": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "email": {
                      "properties": {
                        "address": {
                          "type": "keyword",
                          "ignore_above": 1024
                        }
                      }
                    },
                    "file": {
                      "properties": {
                        "accessed": {
                          "type": "date"
                        },
                        "attributes": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "code_signature": {
                          "properties": {
                            "digest_algorithm": {
                              "type": "keyword",
                              "ignore_above": 1024
                            },
                            "exists": {
                              "type": "boolean"
                            },
                            "signing_id": {
                              "type": "keyword",
                              "ignore_above": 1024
                            },
                            "status": {
                              "type": "keyword",
                              "ignore_above": 1024
                            },
                            "subject_name": {
                              "type": "keyword",
                              "ignore_above": 1024
                            },
                            "team_id": {
                              "type": "keyword",
                              "ignore_above": 1024
                            },
                            "timestamp": {
                              "type": "date"
                            },
                            "trusted": {
                              "type": "boolean"
                            },
                            "valid": {
                              "type": "boolean"
                            }
                          }
                        },
                        "created": {
                          "type": "date"
                        },
                        "ctime": {
                          "type": "date"
                        },
                        "device": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "directory": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "drive_letter": {
                          "type": "keyword",
                          "ignore_above": 1
                        },
                        "elf": {
                          "properties": {
                            "architecture": {
                              "type": "keyword",
                              "ignore_above": 1024
                            },
                            "byte_order": {
                              "type": "keyword",
                              "ignore_above": 1024
                            },
                            "cpu_type": {
                              "type": "keyword",
                              "ignore_above": 1024
                            },
                            "creation_date": {
                              "type": "date"
                            },
                            "exports": {
                              "type": "flattened"
                            },
                            "header": {
                              "properties": {
                                "abi_version": {
                                  "type": "keyword",
                                  "ignore_above": 1024
                                },
                                "class": {
                                  "type": "keyword",
                                  "ignore_above": 1024
                                },
                                "data": {
                                  "type": "keyword",
                                  "ignore_above": 1024
                                },
                                "entrypoint": {
                                  "type": "long"
                                },
                                "object_version": {
                                  "type": "keyword",
                                  "ignore_above": 1024
                                },
                                "os_abi": {
                                  "type": "keyword",
                                  "ignore_above": 1024
                                },
                                "type": {
                                  "type": "keyword",
                                  "ignore_above": 1024
                                },
                                "version": {
                                  "type": "keyword",
                                  "ignore_above": 1024
                                }
                              }
                            },
                            "imports": {
                              "type": "flattened"
                            },
                            "sections": {
                              "type": "nested",
                              "properties": {
                                "chi2": {
                                  "type": "long"
                                },
                                "entropy": {
                                  "type": "long"
                                },
                                "flags": {
                                  "type": "keyword",
                                  "ignore_above": 1024
                                },
                                "name": {
                                  "type": "keyword",
                                  "ignore_above": 1024
                                },
                                "physical_offset": {
                                  "type": "keyword",
                                  "ignore_above": 1024
                                },
                                "physical_size": {
                                  "type": "long"
                                },
                                "type": {
                                  "type": "keyword",
                                  "ignore_above": 1024
                                },
                                "virtual_address": {
                                  "type": "long"
                                },
                                "virtual_size": {
                                  "type": "long"
                                }
                              }
                            },
                            "segments": {
                              "type": "nested",
                              "properties": {
                                "sections": {
                                  "type": "keyword",
                                  "ignore_above": 1024
                                },
                                "type": {
                                  "type": "keyword",
                                  "ignore_above": 1024
                                }
                              }
                            },
                            "shared_libraries": {
                              "type": "keyword",
                              "ignore_above": 1024
                            },
                            "telfhash": {
                              "type": "keyword",
                              "ignore_above": 1024
                            }
                          }
                        },
                        "extension": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "fork_name": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "gid": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "group": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "hash": {
                          "properties": {
                            "md5": {
                              "type": "keyword",
                              "ignore_above": 1024
                            },
                            "sha1": {
                              "type": "keyword",
                              "ignore_above": 1024
                            },
                            "sha256": {
                              "type": "keyword",
                              "ignore_above": 1024
                            },
                            "sha512": {
                              "type": "keyword",
                              "ignore_above": 1024
                            },
                            "ssdeep": {
                              "type": "keyword",
                              "ignore_above": 1024
                            }
                          }
                        },
                        "inode": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "mime_type": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "mode": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "mtime": {
                          "type": "date"
                        },
                        "name": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "owner": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "path": {
                          "type": "keyword",
                          "ignore_above": 1024,
                          "fields": {
                            "text": {
                              "type": "match_only_text"
                            }
                          }
                        },
                        "pe": {
                          "properties": {
                            "architecture": {
                              "type": "keyword",
                              "ignore_above": 1024
                            },
                            "company": {
                              "type": "keyword",
                              "ignore_above": 1024
                            },
                            "description": {
                              "type": "keyword",
                              "ignore_above": 1024
                            },
                            "file_version": {
                              "type": "keyword",
                              "ignore_above": 1024
                            },
                            "imphash": {
                              "type": "keyword",
                              "ignore_above": 1024
                            },
                            "original_file_name": {
                              "type": "keyword",
                              "ignore_above": 1024
                            },
                            "product": {
                              "type": "keyword",
                              "ignore_above": 1024
                            }
                          }
                        },
                        "size": {
                          "type": "long"
                        },
                        "target_path": {
                          "type": "keyword",
                          "ignore_above": 1024,
                          "fields": {
                            "text": {
                              "type": "match_only_text"
                            }
                          }
                        },
                        "type": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "uid": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "x509": {
                          "properties": {
                            "alternative_names": {
                              "type": "keyword",
                              "ignore_above": 1024
                            },
                            "issuer": {
                              "properties": {
                                "common_name": {
                                  "type": "keyword",
                                  "ignore_above": 1024
                                },
                                "country": {
                                  "type": "keyword",
                                  "ignore_above": 1024
                                },
                                "distinguished_name": {
                                  "type": "keyword",
                                  "ignore_above": 1024
                                },
                                "locality": {
                                  "type": "keyword",
                                  "ignore_above": 1024
                                },
                                "organization": {
                                  "type": "keyword",
                                  "ignore_above": 1024
                                },
                                "organizational_unit": {
                                  "type": "keyword",
                                  "ignore_above": 1024
                                },
                                "state_or_province": {
                                  "type": "keyword",
                                  "ignore_above": 1024
                                }
                              }
                            },
                            "not_after": {
                              "type": "date"
                            },
                            "not_before": {
                              "type": "date"
                            },
                            "public_key_algorithm": {
                              "type": "keyword",
                              "ignore_above": 1024
                            },
                            "public_key_curve": {
                              "type": "keyword",
                              "ignore_above": 1024
                            },
                            "public_key_exponent": {
                              "type": "long",
                              "index": false,
                              "doc_values": false
                            },
                            "public_key_size": {
                              "type": "long"
                            },
                            "serial_number": {
                              "type": "keyword",
                              "ignore_above": 1024
                            },
                            "signature_algorithm": {
                              "type": "keyword",
                              "ignore_above": 1024
                            },
                            "subject": {
                              "properties": {
                                "common_name": {
                                  "type": "keyword",
                                  "ignore_above": 1024
                                },
                                "country": {
                                  "type": "keyword",
                                  "ignore_above": 1024
                                },
                                "distinguished_name": {
                                  "type": "keyword",
                                  "ignore_above": 1024
                                },
                                "locality": {
                                  "type": "keyword",
                                  "ignore_above": 1024
                                },
                                "organization": {
                                  "type": "keyword",
                                  "ignore_above": 1024
                                },
                                "organizational_unit": {
                                  "type": "keyword",
                                  "ignore_above": 1024
                                },
                                "state_or_province": {
                                  "type": "keyword",
                                  "ignore_above": 1024
                                }
                              }
                            },
                            "version_number": {
                              "type": "keyword",
                              "ignore_above": 1024
                            }
                          }
                        }
                      }
                    },
                    "first_seen": {
                      "type": "date"
                    },
                    "geo": {
                      "properties": {
                        "city_name": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "continent_code": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "continent_name": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "country_iso_code": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "country_name": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "location": {
                          "type": "geo_point"
                        },
                        "name": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "postal_code": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "region_iso_code": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "region_name": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "timezone": {
                          "type": "keyword",
                          "ignore_above": 1024
                        }
                      }
                    },
                    "ip": {
                      "type": "ip"
                    },
                    "last_seen": {
                      "type": "date"
                    },
                    "marking": {
                      "properties": {
                        "tlp": {
                          "type": "keyword",
                          "ignore_above": 1024
                        }
                      }
                    },
                    "modified_at": {
                      "type": "date"
                    },
                    "port": {
                      "type": "long"
                    },
                    "provider": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "reference": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "registry": {
                      "properties": {
                        "data": {
                          "properties": {
                            "bytes": {
                              "type": "keyword",
                              "ignore_above": 1024
                            },
                            "strings": {
                              "type": "wildcard"
                            },
                            "type": {
                              "type": "keyword",
                              "ignore_above": 1024
                            }
                          }
                        },
                        "hive": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "key": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "path": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "value": {
                          "type": "keyword",
                          "ignore_above": 1024
                        }
                      }
                    },
                    "scanner_stats": {
                      "type": "long"
                    },
                    "sightings": {
                      "type": "long"
                    },
                    "type": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "url": {
                      "properties": {
                        "domain": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "extension": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "fragment": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "full": {
                          "type": "wildcard",
                          "fields": {
                            "text": {
                              "type": "match_only_text"
                            }
                          }
                        },
                        "original": {
                          "type": "wildcard",
                          "fields": {
                            "text": {
                              "type": "match_only_text"
                            }
                          }
                        },
                        "password": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "path": {
                          "type": "wildcard"
                        },
                        "port": {
                          "type": "long"
                        },
                        "query": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "registered_domain": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "scheme": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "subdomain": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "top_level_domain": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "username": {
                          "type": "keyword",
                          "ignore_above": 1024
                        }
                      }
                    },
                    "x509": {
                      "properties": {
                        "alternative_names": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "issuer": {
                          "properties": {
                            "common_name": {
                              "type": "keyword",
                              "ignore_above": 1024
                            },
                            "country": {
                              "type": "keyword",
                              "ignore_above": 1024
                            },
                            "distinguished_name": {
                              "type": "keyword",
                              "ignore_above": 1024
                            },
                            "locality": {
                              "type": "keyword",
                              "ignore_above": 1024
                            },
                            "organization": {
                              "type": "keyword",
                              "ignore_above": 1024
                            },
                            "organizational_unit": {
                              "type": "keyword",
                              "ignore_above": 1024
                            },
                            "state_or_province": {
                              "type": "keyword",
                              "ignore_above": 1024
                            }
                          }
                        },
                        "not_after": {
                          "type": "date"
                        },
                        "not_before": {
                          "type": "date"
                        },
                        "public_key_algorithm": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "public_key_curve": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "public_key_exponent": {
                          "type": "long",
                          "index": false,
                          "doc_values": false
                        },
                        "public_key_size": {
                          "type": "long"
                        },
                        "serial_number": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "signature_algorithm": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "subject": {
                          "properties": {
                            "common_name": {
                              "type": "keyword",
                              "ignore_above": 1024
                            },
                            "country": {
                              "type": "keyword",
                              "ignore_above": 1024
                            },
                            "distinguished_name": {
                              "type": "keyword",
                              "ignore_above": 1024
                            },
                            "locality": {
                              "type": "keyword",
                              "ignore_above": 1024
                            },
                            "organization": {
                              "type": "keyword",
                              "ignore_above": 1024
                            },
                            "organizational_unit": {
                              "type": "keyword",
                              "ignore_above": 1024
                            },
                            "state_or_province": {
                              "type": "keyword",
                              "ignore_above": 1024
                            }
                          }
                        },
                        "version_number": {
                          "type": "keyword",
                          "ignore_above": 1024
                        }
                      }
                    }
                  }
                },
                "matched": {
                  "properties": {
                    "atomic": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "field": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "id": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "index": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "type": {
                      "type": "keyword",
                      "ignore_above": 1024
                    }
                  }
                }
              }
            },
            "framework": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "group": {
              "properties": {
                "alias": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "id": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "name": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "reference": {
                  "type": "keyword",
                  "ignore_above": 1024
                }
              }
            },
            "indicator": {
              "properties": {
                "as": {
                  "properties": {
                    "number": {
                      "type": "long"
                    },
                    "organization": {
                      "properties": {
                        "name": {
                          "type": "keyword",
                          "ignore_above": 1024,
                          "fields": {
                            "text": {
                              "type": "match_only_text"
                            }
                          }
                        }
                      }
                    }
                  }
                },
                "confidence": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "description": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "email": {
                  "properties": {
                    "address": {
                      "type": "keyword",
                      "ignore_above": 1024
                    }
                  }
                },
                "file": {
                  "properties": {
                    "accessed": {
                      "type": "date"
                    },
                    "attributes": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "code_signature": {
                      "properties": {
                        "digest_algorithm": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "exists": {
                          "type": "boolean"
                        },
                        "signing_id": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "status": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "subject_name": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "team_id": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "timestamp": {
                          "type": "date"
                        },
                        "trusted": {
                          "type": "boolean"
                        },
                        "valid": {
                          "type": "boolean"
                        }
                      }
                    },
                    "created": {
                      "type": "date"
                    },
                    "ctime": {
                      "type": "date"
                    },
                    "device": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "directory": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "drive_letter": {
                      "type": "keyword",
                      "ignore_above": 1
                    },
                    "elf": {
                      "properties": {
                        "architecture": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "byte_order": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "cpu_type": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "creation_date": {
                          "type": "date"
                        },
                        "exports": {
                          "type": "flattened"
                        },
                        "header": {
                          "properties": {
                            "abi_version": {
                              "type": "keyword",
                              "ignore_above": 1024
                            },
                            "class": {
                              "type": "keyword",
                              "ignore_above": 1024
                            },
                            "data": {
                              "type": "keyword",
                              "ignore_above": 1024
                            },
                            "entrypoint": {
                              "type": "long"
                            },
                            "object_version": {
                              "type": "keyword",
                              "ignore_above": 1024
                            },
                            "os_abi": {
                              "type": "keyword",
                              "ignore_above": 1024
                            },
                            "type": {
                              "type": "keyword",
                              "ignore_above": 1024
                            },
                            "version": {
                              "type": "keyword",
                              "ignore_above": 1024
                            }
                          }
                        },
                        "imports": {
                          "type": "flattened"
                        },
                        "sections": {
                          "type": "nested",
                          "properties": {
                            "chi2": {
                              "type": "long"
                            },
                            "entropy": {
                              "type": "long"
                            },
                            "flags": {
                              "type": "keyword",
                              "ignore_above": 1024
                            },
                            "name": {
                              "type": "keyword",
                              "ignore_above": 1024
                            },
                            "physical_offset": {
                              "type": "keyword",
                              "ignore_above": 1024
                            },
                            "physical_size": {
                              "type": "long"
                            },
                            "type": {
                              "type": "keyword",
                              "ignore_above": 1024
                            },
                            "virtual_address": {
                              "type": "long"
                            },
                            "virtual_size": {
                              "type": "long"
                            }
                          }
                        },
                        "segments": {
                          "type": "nested",
                          "properties": {
                            "sections": {
                              "type": "keyword",
                              "ignore_above": 1024
                            },
                            "type": {
                              "type": "keyword",
                              "ignore_above": 1024
                            }
                          }
                        },
                        "shared_libraries": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "telfhash": {
                          "type": "keyword",
                          "ignore_above": 1024
                        }
                      }
                    },
                    "extension": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "fork_name": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "gid": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "group": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "hash": {
                      "properties": {
                        "md5": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "sha1": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "sha256": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "sha512": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "ssdeep": {
                          "type": "keyword",
                          "ignore_above": 1024
                        }
                      }
                    },
                    "inode": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "mime_type": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "mode": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "mtime": {
                      "type": "date"
                    },
                    "name": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "owner": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "path": {
                      "type": "keyword",
                      "ignore_above": 1024,
                      "fields": {
                        "text": {
                          "type": "match_only_text"
                        }
                      }
                    },
                    "pe": {
                      "properties": {
                        "architecture": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "company": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "description": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "file_version": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "imphash": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "original_file_name": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "product": {
                          "type": "keyword",
                          "ignore_above": 1024
                        }
                      }
                    },
                    "size": {
                      "type": "long"
                    },
                    "target_path": {
                      "type": "keyword",
                      "ignore_above": 1024,
                      "fields": {
                        "text": {
                          "type": "match_only_text"
                        }
                      }
                    },
                    "type": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "uid": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "x509": {
                      "properties": {
                        "alternative_names": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "issuer": {
                          "properties": {
                            "common_name": {
                              "type": "keyword",
                              "ignore_above": 1024
                            },
                            "country": {
                              "type": "keyword",
                              "ignore_above": 1024
                            },
                            "distinguished_name": {
                              "type": "keyword",
                              "ignore_above": 1024
                            },
                            "locality": {
                              "type": "keyword",
                              "ignore_above": 1024
                            },
                            "organization": {
                              "type": "keyword",
                              "ignore_above": 1024
                            },
                            "organizational_unit": {
                              "type": "keyword",
                              "ignore_above": 1024
                            },
                            "state_or_province": {
                              "type": "keyword",
                              "ignore_above": 1024
                            }
                          }
                        },
                        "not_after": {
                          "type": "date"
                        },
                        "not_before": {
                          "type": "date"
                        },
                        "public_key_algorithm": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "public_key_curve": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "public_key_exponent": {
                          "type": "long",
                          "index": false,
                          "doc_values": false
                        },
                        "public_key_size": {
                          "type": "long"
                        },
                        "serial_number": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "signature_algorithm": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "subject": {
                          "properties": {
                            "common_name": {
                              "type": "keyword",
                              "ignore_above": 1024
                            },
                            "country": {
                              "type": "keyword",
                              "ignore_above": 1024
                            },
                            "distinguished_name": {
                              "type": "keyword",
                              "ignore_above": 1024
                            },
                            "locality": {
                              "type": "keyword",
                              "ignore_above": 1024
                            },
                            "organization": {
                              "type": "keyword",
                              "ignore_above": 1024
                            },
                            "organizational_unit": {
                              "type": "keyword",
                              "ignore_above": 1024
                            },
                            "state_or_province": {
                              "type": "keyword",
                              "ignore_above": 1024
                            }
                          }
                        },
                        "version_number": {
                          "type": "keyword",
                          "ignore_above": 1024
                        }
                      }
                    }
                  }
                },
                "first_seen": {
                  "type": "date"
                },
                "geo": {
                  "properties": {
                    "city_name": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "continent_code": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "continent_name": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "country_iso_code": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "country_name": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "location": {
                      "type": "geo_point"
                    },
                    "name": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "postal_code": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "region_iso_code": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "region_name": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "timezone": {
                      "type": "keyword",
                      "ignore_above": 1024
                    }
                  }
                },
                "ip": {
                  "type": "ip"
                },
                "last_seen": {
                  "type": "date"
                },
                "marking": {
                  "properties": {
                    "tlp": {
                      "type": "keyword",
                      "ignore_above": 1024
                    }
                  }
                },
                "modified_at": {
                  "type": "date"
                },
                "port": {
                  "type": "long"
                },
                "provider": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "reference": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "registry": {
                  "properties": {
                    "data": {
                      "properties": {
                        "bytes": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "strings": {
                          "type": "wildcard"
                        },
                        "type": {
                          "type": "keyword",
                          "ignore_above": 1024
                        }
                      }
                    },
                    "hive": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "key": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "path": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "value": {
                      "type": "keyword",
                      "ignore_above": 1024
                    }
                  }
                },
                "scanner_stats": {
                  "type": "long"
                },
                "sightings": {
                  "type": "long"
                },
                "type": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "url": {
                  "properties": {
                    "domain": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "extension": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "fragment": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "full": {
                      "type": "wildcard",
                      "fields": {
                        "text": {
                          "type": "match_only_text"
                        }
                      }
                    },
                    "original": {
                      "type": "wildcard",
                      "fields": {
                        "text": {
                          "type": "match_only_text"
                        }
                      }
                    },
                    "password": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "path": {
                      "type": "wildcard"
                    },
                    "port": {
                      "type": "long"
                    },
                    "query": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "registered_domain": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "scheme": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "subdomain": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "top_level_domain": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "username": {
                      "type": "keyword",
                      "ignore_above": 1024
                    }
                  }
                },
                "x509": {
                  "properties": {
                    "alternative_names": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "issuer": {
                      "properties": {
                        "common_name": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "country": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "distinguished_name": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "locality": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "organization": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "organizational_unit": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "state_or_province": {
                          "type": "keyword",
                          "ignore_above": 1024
                        }
                      }
                    },
                    "not_after": {
                      "type": "date"
                    },
                    "not_before": {
                      "type": "date"
                    },
                    "public_key_algorithm": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "public_key_curve": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "public_key_exponent": {
                      "type": "long",
                      "index": false,
                      "doc_values": false
                    },
                    "public_key_size": {
                      "type": "long"
                    },
                    "serial_number": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "signature_algorithm": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "subject": {
                      "properties": {
                        "common_name": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "country": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "distinguished_name": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "locality": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "organization": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "organizational_unit": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "state_or_province": {
                          "type": "keyword",
                          "ignore_above": 1024
                        }
                      }
                    },
                    "version_number": {
                      "type": "keyword",
                      "ignore_above": 1024
                    }
                  }
                }
              }
            },
            "software": {
              "properties": {
                "alias": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "id": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "name": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "platforms": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "reference": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "type": {
                  "type": "keyword",
                  "ignore_above": 1024
                }
              }
            },
            "tactic": {
              "properties": {
                "id": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "name": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "reference": {
                  "type": "keyword",
                  "ignore_above": 1024
                }
              }
            },
            "technique": {
              "properties": {
                "id": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "name": {
                  "type": "keyword",
                  "ignore_above": 1024,
                  "fields": {
                    "text": {
                      "type": "match_only_text"
                    }
                  }
                },
                "reference": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "subtechnique": {
                  "properties": {
                    "id": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "name": {
                      "type": "keyword",
                      "ignore_above": 1024,
                      "fields": {
                        "text": {
                          "type": "match_only_text"
                        }
                      }
                    },
                    "reference": {
                      "type": "keyword",
                      "ignore_above": 1024
                    }
                  }
                }
              }
            }
          }
        },
        "tls": {
          "properties": {
            "cipher": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "client": {
              "properties": {
                "certificate": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "certificate_chain": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "hash": {
                  "properties": {
                    "md5": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "sha1": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "sha256": {
                      "type": "keyword",
                      "ignore_above": 1024
                    }
                  }
                },
                "issuer": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "ja3": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "not_after": {
                  "type": "date"
                },
                "not_before": {
                  "type": "date"
                },
                "server_name": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "subject": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "supported_ciphers": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "x509": {
                  "properties": {
                    "alternative_names": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "issuer": {
                      "properties": {
                        "common_name": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "country": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "distinguished_name": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "locality": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "organization": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "organizational_unit": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "state_or_province": {
                          "type": "keyword",
                          "ignore_above": 1024
                        }
                      }
                    },
                    "not_after": {
                      "type": "date"
                    },
                    "not_before": {
                      "type": "date"
                    },
                    "public_key_algorithm": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "public_key_curve": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "public_key_exponent": {
                      "type": "long",
                      "index": false,
                      "doc_values": false
                    },
                    "public_key_size": {
                      "type": "long"
                    },
                    "serial_number": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "signature_algorithm": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "subject": {
                      "properties": {
                        "common_name": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "country": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "distinguished_name": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "locality": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "organization": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "organizational_unit": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "state_or_province": {
                          "type": "keyword",
                          "ignore_above": 1024
                        }
                      }
                    },
                    "version_number": {
                      "type": "keyword",
                      "ignore_above": 1024
                    }
                  }
                }
              }
            },
            "curve": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "established": {
              "type": "boolean"
            },
            "next_protocol": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "resumed": {
              "type": "boolean"
            },
            "server": {
              "properties": {
                "certificate": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "certificate_chain": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "hash": {
                  "properties": {
                    "md5": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "sha1": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "sha256": {
                      "type": "keyword",
                      "ignore_above": 1024
                    }
                  }
                },
                "issuer": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "ja3s": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "not_after": {
                  "type": "date"
                },
                "not_before": {
                  "type": "date"
                },
                "subject": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "x509": {
                  "properties": {
                    "alternative_names": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "issuer": {
                      "properties": {
                        "common_name": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "country": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "distinguished_name": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "locality": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "organization": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "organizational_unit": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "state_or_province": {
                          "type": "keyword",
                          "ignore_above": 1024
                        }
                      }
                    },
                    "not_after": {
                      "type": "date"
                    },
                    "not_before": {
                      "type": "date"
                    },
                    "public_key_algorithm": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "public_key_curve": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "public_key_exponent": {
                      "type": "long",
                      "index": false,
                      "doc_values": false
                    },
                    "public_key_size": {
                      "type": "long"
                    },
                    "serial_number": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "signature_algorithm": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "subject": {
                      "properties": {
                        "common_name": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "country": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "distinguished_name": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "locality": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "organization": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "organizational_unit": {
                          "type": "keyword",
                          "ignore_above": 1024
                        },
                        "state_or_province": {
                          "type": "keyword",
                          "ignore_above": 1024
                        }
                      }
                    },
                    "version_number": {
                      "type": "keyword",
                      "ignore_above": 1024
                    }
                  }
                }
              }
            },
            "version": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "version_protocol": {
              "type": "keyword",
              "ignore_above": 1024
            }
          }
        },
        "trace": {
          "properties": {
            "id": {
              "type": "keyword",
              "ignore_above": 1024
            }
          }
        },
        "transaction": {
          "properties": {
            "id": {
              "type": "keyword",
              "ignore_above": 1024
            }
          }
        },
        "url": {
          "properties": {
            "domain": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "extension": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "fragment": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "full": {
              "type": "wildcard",
              "fields": {
                "text": {
                  "type": "match_only_text"
                }
              }
            },
            "original": {
              "type": "wildcard",
              "fields": {
                "text": {
                  "type": "match_only_text"
                }
              }
            },
            "password": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "path": {
              "type": "wildcard"
            },
            "port": {
              "type": "long"
            },
            "query": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "registered_domain": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "scheme": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "subdomain": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "top_level_domain": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "username": {
              "type": "keyword",
              "ignore_above": 1024
            }
          }
        },
        "user": {
          "properties": {
            "changes": {
              "properties": {
                "domain": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "email": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "full_name": {
                  "type": "keyword",
                  "ignore_above": 1024,
                  "fields": {
                    "text": {
                      "type": "match_only_text"
                    }
                  }
                },
                "group": {
                  "properties": {
                    "domain": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "id": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "name": {
                      "type": "keyword",
                      "ignore_above": 1024
                    }
                  }
                },
                "hash": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "id": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "name": {
                  "type": "keyword",
                  "ignore_above": 1024,
                  "fields": {
                    "text": {
                      "type": "match_only_text"
                    }
                  }
                },
                "roles": {
                  "type": "keyword",
                  "ignore_above": 1024
                }
              }
            },
            "domain": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "effective": {
              "properties": {
                "domain": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "email": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "full_name": {
                  "type": "keyword",
                  "ignore_above": 1024,
                  "fields": {
                    "text": {
                      "type": "match_only_text"
                    }
                  }
                },
                "group": {
                  "properties": {
                    "domain": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "id": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "name": {
                      "type": "keyword",
                      "ignore_above": 1024
                    }
                  }
                },
                "hash": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "id": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "name": {
                  "type": "keyword",
                  "ignore_above": 1024,
                  "fields": {
                    "text": {
                      "type": "match_only_text"
                    }
                  }
                },
                "roles": {
                  "type": "keyword",
                  "ignore_above": 1024
                }
              }
            },
            "email": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "full_name": {
              "type": "keyword",
              "ignore_above": 1024,
              "fields": {
                "text": {
                  "type": "match_only_text"
                }
              }
            },
            "group": {
              "properties": {
                "domain": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "id": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "name": {
                  "type": "keyword",
                  "ignore_above": 1024
                }
              }
            },
            "hash": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "id": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "name": {
              "type": "keyword",
              "ignore_above": 1024,
              "fields": {
                "text": {
                  "type": "match_only_text"
                }
              }
            },
            "roles": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "target": {
              "properties": {
                "domain": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "email": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "full_name": {
                  "type": "keyword",
                  "ignore_above": 1024,
                  "fields": {
                    "text": {
                      "type": "match_only_text"
                    }
                  }
                },
                "group": {
                  "properties": {
                    "domain": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "id": {
                      "type": "keyword",
                      "ignore_above": 1024
                    },
                    "name": {
                      "type": "keyword",
                      "ignore_above": 1024
                    }
                  }
                },
                "hash": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "id": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "name": {
                  "type": "keyword",
                  "ignore_above": 1024,
                  "fields": {
                    "text": {
                      "type": "match_only_text"
                    }
                  }
                },
                "roles": {
                  "type": "keyword",
                  "ignore_above": 1024
                }
              }
            }
          }
        },
        "user_agent": {
          "properties": {
            "device": {
              "properties": {
                "name": {
                  "type": "keyword",
                  "ignore_above": 1024
                }
              }
            },
            "name": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "original": {
              "type": "keyword",
              "ignore_above": 1024,
              "fields": {
                "text": {
                  "type": "match_only_text"
                }
              }
            },
            "os": {
              "properties": {
                "family": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "full": {
                  "type": "keyword",
                  "ignore_above": 1024,
                  "fields": {
                    "text": {
                      "type": "match_only_text"
                    }
                  }
                },
                "kernel": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "name": {
                  "type": "keyword",
                  "ignore_above": 1024,
                  "fields": {
                    "text": {
                      "type": "match_only_text"
                    }
                  }
                },
                "platform": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "type": {
                  "type": "keyword",
                  "ignore_above": 1024
                },
                "version": {
                  "type": "keyword",
                  "ignore_above": 1024
                }
              }
            },
            "version": {
              "type": "keyword",
              "ignore_above": 1024
            }
          }
        },
        "vulnerability": {
          "properties": {
            "category": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "classification": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "description": {
              "type": "keyword",
              "ignore_above": 1024,
              "fields": {
                "text": {
                  "type": "match_only_text"
                }
              }
            },
            "enumeration": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "id": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "reference": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "report_id": {
              "type": "keyword",
              "ignore_above": 1024
            },
            "scanner": {
              "properties": {
                "vendor": {
                  "type": "keyword",
                  "ignore_above": 1024
                }
              }
            },
            "score": {
              "properties": {
                "base": {
                  "type": "float"
                },
                "environmental": {
                  "type": "float"
                },
                "temporal": {
                  "type": "float"
                },
                "version": {
                  "type": "keyword",
                  "ignore_above": 1024
                }
              }
            },
            "severity": {
              "type": "keyword",
              "ignore_above": 1024
            }
          }
        }
      }
    },
    "aliases": {}
  }
}
'
curl -X PUT "localhost:9200/_ilm/policy/pfelk-ilm?pretty" -H 'Content-Type: application/json' -d'
{
  "policy": {
    "phases": {
      "hot": {
        "min_age": "0ms",
        "actions": {
          "rollover": {
            "max_age": "30d",
            "max_primary_shard_size": "50gb"
          }
        }
      },
      "warm": {
        "min_age": "60d",
        "actions": {
          "set_priority": {
            "priority": 50
          }
        }
      },
      "cold": {
        "min_age": "92d",
        "actions": {
          "set_priority": {
            "priority": 0
          }
        }
      }
    },
    "_meta": {
      "managed": true,
      "description": "default policy for the logs index template installed by x-pack"
    }
  }
}
'
curl -X PUT "localhost:9200/_index_template/pfelk?pretty" -H 'Content-Type: application/json' -d'
{
  "version": 22,
  "priority": 50,
  "template": {
    "settings": {
      "index": {
        "lifecycle": {
          "name": "pfelk"
        }
      }
    },
    "mappings": {
      "_routing": {
        "required": false
      },
      "numeric_detection": false,
      "dynamic_date_formats": [
        "strict_date_optional_time",
        "yyyy/MM/dd HH:mm:ss Z||yyyy/MM/dd Z"
      ],
      "_source": {
        "excludes": [],
        "includes": [],
        "enabled": true
      },
      "dynamic": true,
      "dynamic_templates": [],
      "date_detection": true,
      "properties": {
        "pf": {
          "type": "object",
          "properties": {
            "tcp": {
              "type": "object",
              "properties": {
                "sequence_number": {
                  "type": "long"
                },
                "data_length": {
                  "type": "integer"
                },
                "flags": {
                  "type": "keyword"
                },
                "options": {
                  "eager_global_ordinals": false,
                  "index_phrases": false,
                  "fielddata": false,
                  "norms": true,
                  "index": true,
                  "store": false,
                  "type": "text",
                  "fields": {
                    "keyword": {
                      "type": "keyword"
                    }
                  },
                  "index_options": "positions"
                },
                "window": {
                  "type": "integer"
                }
              }
            },
            "ipv4": {
              "type": "object",
              "properties": {
                "offset": {
                  "type": "integer"
                },
                "flags": {
                  "type": "keyword"
                },
                "tos": {
                  "type": "keyword"
                },
                "packet": {
                  "type": "object",
                  "properties": {
                    "id": {
                      "type": "integer"
                    }
                  }
                },
                "ttl": {
                  "type": "integer"
                }
              }
            },
            "transport": {
              "type": "object",
              "properties": {
                "data_length": {
                  "type": "integer"
                }
              }
            },
            "packet": {
              "type": "object",
              "properties": {
                "length": {
                  "type": "integer"
                }
              }
            }
          }
        }
      }
    }
  },
  "index_patterns": [
    "*-pfelk-captive*",
    "*-pfelk-firewall*",
    "*-pfelk-snort*",
    "*-pfelk-squid*",
    "*-pfelk-unbound*"
  ],
  "data_stream": {
    "hidden": false
  },
  "composed_of": [
    "pfelk-settings",
    "pfelk-mappings-ecs"
  ],
  "_meta": {
    "managed": true,
    "description": "default pfelk indexes installed by pfelk"
  }
}
'
curl -X PUT "localhost:9200/_index_template/pfelk-dhcp?pretty" -H 'Content-Type: application/json' -d'
{
  "version": 22,
  "priority": 51,
  "template": {
    "settings": {
      "index": {
        "lifecycle": {
          "name": "pfelk"
        }
      }
    },
    "mappings": {
      "_routing": {
        "required": false
      },
      "numeric_detection": false,
      "dynamic_date_formats": [
        "strict_date_optional_time",
        "yyyy/MM/dd HH:mm:ss Z||yyyy/MM/dd Z"
      ],
      "dynamic": true,
      "_source": {
        "excludes": [],
        "includes": [],
        "enabled": true
      },
      "dynamic_templates": [],
      "date_detection": true,
      "properties": {
        "dhcpv4": {
          "type": "object",
          "properties": {
            "server": {
              "type": "object",
              "properties": {
                "ip": {
                  "type": "ip"
                },
                "Mac": {
                  "type": "keyword"
                }
              }
            },
            "query": {
              "type": "object",
              "properties": {
                "associated": {
                  "type": "text"
                },
                "ip": {
                  "type": "ip"
                },
                "Mac": {
                  "type": "keyword"
                }
              }
            },
            "client": {
              "type": "object",
              "properties": {
                "ip": {
                  "type": "ip"
                },
                "mac": {
                  "type": "keyword"
                }
              }
            },
            "option": {
              "type": "object",
              "properties": {
                "hostname": {
                  "type": "keyword"
                },
                "message": {
                  "type": "text"
                }
              }
            }
          }
        },
        "dhcpv6": {
          "type": "object"
        },
        "dhcp": {
          "type": "object",
          "properties": {
            "client": {
              "type": "object",
              "properties": {
                "ip": {
                  "type": "ip"
                },
                "mac": {
                  "type": "keyword"
                }
              }
            },
            "message": {
              "type": "text"
            },
            "operation": {
              "type": "keyword"
            }
          }
        }
      }
    }
  },
  "index_patterns": [
    "*-pfelk-dhcp*"
  ],
  "data_stream": {
    "hidden": false
  },
  "composed_of": [
    "pfelk-settings",
    "pfelk-mappings-ecs"
  ],
  "_meta": {
    "managed": true,
    "description": "default dhcp indexes installed by pfelk"
  }
}
'
curl -X PUT "localhost:9200/_index_template/pfelk-haproxy?pretty" -H 'Content-Type: application/json' -d'
{
  "version": 22,
  "priority": 57,
  "template": {
    "settings": {
      "index": {
        "lifecycle": {
          "name": "pfelk"
        }
      }
    },
    "mappings": {
      "_routing": {
        "required": false
      },
      "numeric_detection": false,
      "_source": {
        "excludes": [],
        "includes": [],
        "enabled": true
      },
      "dynamic": true,
      "dynamic_templates": [],
      "date_detection": false,
      "properties": {
        "haproxy": {
          "type": "object",
          "properties": {
            "server_name": {
              "eager_global_ordinals": false,
              "norms": false,
              "index": true,
              "store": false,
              "type": "keyword",
              "fields": {
                "text": {
                  "type": "text"
                }
              },
              "index_options": "docs",
              "split_queries_on_whitespace": false,
              "doc_values": true
            },
            "termination_state": {
              "eager_global_ordinals": false,
              "norms": false,
              "index": true,
              "store": false,
              "type": "keyword",
              "fields": {
                "text": {
                  "type": "text"
                }
              },
              "index_options": "docs",
              "split_queries_on_whitespace": false,
              "doc_values": true
            },
            "time_queue": {
              "type": "long"
            },
            "bytes_read": {
              "type": "long"
            },
            "mode": {
              "type": "keyword"
            },
            "backend_queue": {
              "type": "long"
            },
            "backend_name": {
              "eager_global_ordinals": false,
              "norms": false,
              "index": true,
              "store": false,
              "type": "keyword",
              "fields": {
                "text": {
                  "type": "text"
                }
              },
              "index_options": "docs",
              "split_queries_on_whitespace": false,
              "doc_values": true
            },
            "frontend_name": {
              "eager_global_ordinals": false,
              "norms": false,
              "index": true,
              "store": false,
              "type": "keyword",
              "fields": {
                "text": {
                  "type": "text"
                }
              },
              "index_options": "docs",
              "split_queries_on_whitespace": false,
              "doc_values": true
            },
            "http": {
              "type": "object",
              "properties": {
                "request": {
                  "type": "object",
                  "properties": {
                    "captured_cookie": {
                      "type": "text",
                      "fields": {
                        "keyword": {
                          "type": "keyword"
                        }
                      }
                    }
                  }
                },
                "response": {
                  "type": "object",
                  "properties": {
                    "captured_cookie": {
                      "type": "text",
                      "fields": {
                        "keyword": {
                          "type": "keyword"
                        }
                      }
                    }
                  }
                }
              }
            },
            "server_queue": {
              "type": "long"
            },
            "time_backend_connect": {
              "type": "long"
            },
            "connections": {
              "type": "object",
              "properties": {
                "retries": {
                  "type": "long"
                },
                "server": {
                  "type": "long"
                },
                "active": {
                  "type": "long"
                },
                "backend": {
                  "type": "long"
                },
                "frontend": {
                  "type": "long"
                }
              }
            },
            "timestamp": {
              "format": "strict_date_optional_time||epoch_millis||dd/MMM/yyyy:HH:mm:ss.SSS",
              "index": true,
              "ignore_malformed": false,
              "store": false,
              "type": "date",
              "doc_values": true
            }
          }
        }
      }
    }
  },
  "index_patterns": [
    "*-pfelk-haproxy*"
  ],
  "data_stream": {
    "hidden": false
  },
  "composed_of": [
    "pfelk-settings",
    "pfelk-mappings-ecs"
  ],
  "_meta": {
    "managed": true,
    "description": "default haproxy indexes installed by pfelk"
  }
}
'
curl -X PUT "localhost:9200/_index_template/pfelk-suricata?pretty" -H 'Content-Type: application/json' -d'
{
  "version": 22,
  "priority": 55,
  "template": {
    "settings": {
      "index": {
        "lifecycle": {
          "name": "pfelk"
        }
      }
    },
    "mappings": {
      "_routing": {
        "required": false
      },
      "numeric_detection": false,
      "dynamic_date_formats": [
        "strict_date_optional_time",
        "yyyy/MM/dd HH:mm:ss Z||yyyy/MM/dd Z"
      ],
      "_source": {
        "excludes": [],
        "includes": [],
        "enabled": true
      },
      "dynamic": true,
      "dynamic_templates": [],
      "date_detection": true,
      "properties": {
        "suricata": {
          "type": "object",
          "properties": {
            "eve": {
              "type": "object",
              "properties": {
                "tcp": {
                  "type": "object",
                  "properties": {
                    "rst": {
                      "type": "boolean"
                    },
                    "tcp_flags_tc": {
                      "type": "keyword"
                    },
                    "tcp_flags_ts": {
                      "type": "keyword"
                    },
                    "psh": {
                      "type": "boolean"
                    },
                    "tcp_flags": {
                      "type": "keyword"
                    },
                    "ack": {
                      "type": "boolean"
                    },
                    "syn": {
                      "type": "boolean"
                    },
                    "fin": {
                      "type": "boolean"
                    },
                    "state": {
                      "type": "keyword"
                    }
                  }
                },
                "icmp_type": {
                  "type": "long"
                },
                "smtp": {
                  "type": "object",
                  "properties": {
                    "helo": {
                      "type": "keyword"
                    },
                    "rcpt_to": {
                      "type": "keyword"
                    },
                    "mail_from": {
                      "type": "keyword"
                    }
                  }
                },
                "pcap_cnt": {
                  "type": "long"
                },
                "dns": {
                  "type": "object",
                  "properties": {
                    "rdata": {
                      "type": "keyword"
                    },
                    "rrname": {
                      "type": "keyword"
                    },
                    "rcode": {
                      "type": "keyword"
                    },
                    "id": {
                      "type": "long"
                    },
                    "tx_id": {
                      "type": "long"
                    },
                    "type": {
                      "type": "keyword"
                    },
                    "ttl": {
                      "type": "long"
                    },
                    "rrtype": {
                      "type": "keyword"
                    }
                  }
                },
                "ssh": {
                  "type": "object",
                  "properties": {
                    "server": {
                      "type": "object",
                      "properties": {
                        "proto_version": {
                          "type": "keyword"
                        },
                        "software_version": {
                          "type": "keyword"
                        }
                      }
                    },
                    "client": {
                      "type": "object",
                      "properties": {
                        "proto_version": {
                          "type": "keyword"
                        },
                        "software_version": {
                          "type": "keyword"
                        }
                      }
                    }
                  }
                },
                "app_proto_tc": {
                  "type": "keyword"
                },
                "tx_id": {
                  "type": "long"
                },
                "app_proto_orig": {
                  "type": "keyword"
                },
                "in_iface": {
                  "type": "keyword"
                },
                "event_type": {
                  "type": "keyword"
                },
                "alert": {
                  "type": "object",
                  "properties": {
                    "rev": {
                      "type": "long"
                    },
                    "signature_id": {
                      "type": "long"
                    },
                    "gid": {
                      "type": "long"
                    },
                    "signature": {
                      "type": "keyword"
                    },
                    "category": {
                      "type": "keyword"
                    }
                  }
                },
                "stats": {
                  "type": "object",
                  "properties": {
                    "defrag": {
                      "type": "object",
                      "properties": {
                        "ipv4": {
                          "type": "object",
                          "properties": {
                            "reassembled": {
                              "type": "long"
                            },
                            "timeouts": {
                              "type": "long"
                            },
                            "fragments": {
                              "type": "long"
                            }
                          }
                        },
                        "ipv6": {
                          "type": "object",
                          "properties": {
                            "reassembled": {
                              "type": "long"
                            },
                            "timeouts": {
                              "type": "long"
                            },
                            "fragments": {
                              "type": "long"
                            }
                          }
                        }
                      }
                    },
                    "tcp": {
                      "type": "object",
                      "properties": {
                        "insert_data_overlap_fail": {
                          "type": "long"
                        },
                        "invalid_checksum": {
                          "type": "long"
                        },
                        "ssn_memcap_drop": {
                          "type": "long"
                        },
                        "sessions": {
                          "type": "long"
                        },
                        "overlap_diff_data": {
                          "type": "long"
                        },
                        "stream_depth_reached": {
                          "type": "long"
                        },
                        "syn": {
                          "type": "long"
                        },
                        "no_flow": {
                          "type": "long"
                        },
                        "segment_memcap_drop": {
                          "type": "long"
                        },
                        "memuse": {
                          "type": "long"
                        },
                        "pseudo_failed": {
                          "type": "long"
                        },
                        "reassembly_gap": {
                          "type": "long"
                        },
                        "rst": {
                          "type": "long"
                        },
                        "overlap": {
                          "type": "long"
                        },
                        "insert_list_fail": {
                          "coerce": true,
                          "index": true,
                          "ignore_malformed": false,
                          "store": false,
                          "type": "long",
                          "doc_values": true
                        },
                        "synack": {
                          "type": "long"
                        },
                        "pseudo": {
                          "type": "long"
                        },
                        "reassembly_memuse": {
                          "type": "long"
                        },
                        "insert_data_normal_fail": {
                          "type": "long"
                        }
                      }
                    },
                    "app_layer": {
                      "type": "object",
                      "properties": {
                        "tx": {
                          "type": "object",
                          "properties": {
                            "dcerpc_tcp": {
                              "type": "long"
                            },
                            "dcerpc_udp": {
                              "type": "long"
                            },
                            "ftp": {
                              "type": "long"
                            },
                            "smtp": {
                              "type": "long"
                            },
                            "http": {
                              "type": "long"
                            },
                            "smb": {
                              "type": "long"
                            },
                            "ssh": {
                              "type": "long"
                            },
                            "tls": {
                              "type": "long"
                            },
                            "dns_tcp": {
                              "type": "long"
                            },
                            "dns_udp": {
                              "type": "long"
                            }
                          }
                        },
                        "flow": {
                          "type": "object",
                          "properties": {
                            "dcerpc_tcp": {
                              "type": "long"
                            },
                            "dcerpc_udp": {
                              "type": "long"
                            },
                            "imap": {
                              "type": "long"
                            },
                            "ftp": {
                              "type": "long"
                            },
                            "smtp": {
                              "type": "long"
                            },
                            "msn": {
                              "type": "long"
                            },
                            "smb": {
                              "type": "long"
                            },
                            "ssh": {
                              "type": "long"
                            },
                            "failed_tcp": {
                              "type": "long"
                            },
                            "failed_udp": {
                              "type": "long"
                            },
                            "dns_tcp": {
                              "type": "long"
                            },
                            "dns_udp": {
                              "type": "long"
                            },
                            "http": {
                              "type": "long"
                            },
                            "tls": {
                              "type": "long"
                            }
                          }
                        }
                      }
                    },
                    "dns": {
                      "type": "object",
                      "properties": {
                        "memuse": {
                          "type": "long"
                        },
                        "memcap_state": {
                          "type": "long"
                        },
                        "memcap_global": {
                          "type": "long"
                        }
                      }
                    },
                    "capture": {
                      "type": "object",
                      "properties": {
                        "kernel_drops": {
                          "type": "long"
                        },
                        "kernel_ifdrops": {
                          "type": "long"
                        },
                        "kernel_packets": {
                          "type": "long"
                        }
                      }
                    },
                    "detect": {
                      "type": "object",
                      "properties": {
                        "alert": {
                          "type": "long"
                        }
                      }
                    },
                    "http": {
                      "type": "object",
                      "properties": {
                        "memuse": {
                          "type": "long"
                        },
                        "memcap": {
                          "type": "long"
                        }
                      }
                    },
                    "decoder": {
                      "type": "object",
                      "properties": {
                        "udp": {
                          "type": "long"
                        },
                        "dce": {
                          "type": "object",
                          "properties": {
                            "pkt_too_small": {
                              "type": "long"
                            }
                          }
                        },
                        "ieee8021ah": {
                          "type": "long"
                        },
                        "ipv4": {
                          "type": "long"
                        },
                        "vlan": {
                          "type": "long"
                        },
                        "ipv6": {
                          "type": "long"
                        },
                        "pppoe": {
                          "type": "long"
                        },
                        "mpls": {
                          "type": "long"
                        },
                        "teredo": {
                          "type": "long"
                        },
                        "gre": {
                          "type": "long"
                        },
                        "max_pkt_size": {
                          "type": "long"
                        },
                        "vlan_qinq": {
                          "type": "long"
                        },
                        "ipraw": {
                          "type": "object",
                          "properties": {
                            "invalid_ip_version": {
                              "type": "long"
                            }
                          }
                        },
                        "tcp": {
                          "type": "long"
                        },
                        "erspan": {
                          "type": "long"
                        },
                        "icmpv4": {
                          "type": "long"
                        },
                        "raw": {
                          "type": "long"
                        },
                        "ipv4_in_ipv6": {
                          "type": "long"
                        },
                        "icmpv6": {
                          "type": "long"
                        },
                        "ltnull": {
                          "type": "object",
                          "properties": {
                            "unsupported_type": {
                              "type": "long"
                            },
                            "pkt_too_small": {
                              "type": "long"
                            }
                          }
                        },
                        "ethernet": {
                          "type": "long"
                        },
                        "ppp": {
                          "type": "long"
                        },
                        "sll": {
                          "type": "long"
                        },
                        "null": {
                          "type": "long"
                        },
                        "bytes": {
                          "type": "long"
                        },
                        "avg_pkt_size": {
                          "type": "long"
                        },
                        "invalid": {
                          "type": "long"
                        },
                        "sctp": {
                          "type": "long"
                        },
                        "ipv6_in_ipv6": {
                          "type": "long"
                        }
                      }
                    },
                    "flow_mgr": {
                      "type": "object",
                      "properties": {
                        "bypassed_pruned": {
                          "type": "long"
                        },
                        "closed_pruned": {
                          "type": "long"
                        },
                        "rows_empty": {
                          "type": "long"
                        },
                        "flows_notimeout": {
                          "type": "long"
                        },
                        "flows_checked": {
                          "type": "long"
                        },
                        "flows_timeout_inuse": {
                          "type": "long"
                        },
                        "rows_maxlen": {
                          "type": "long"
                        },
                        "flows_removed": {
                          "type": "long"
                        },
                        "rows_checked": {
                          "type": "long"
                        },
                        "flows_timeout": {
                          "type": "long"
                        },
                        "est_pruned": {
                          "type": "long"
                        },
                        "rows_busy": {
                          "type": "long"
                        },
                        "new_pruned": {
                          "type": "long"
                        },
                        "rows_skipped": {
                          "type": "long"
                        }
                      }
                    },
                    "file_store": {
                      "type": "object",
                      "properties": {
                        "open_files": {
                          "type": "long"
                        }
                      }
                    },
                    "flow": {
                      "type": "object",
                      "properties": {
                        "emerg_mode_entered": {
                          "type": "long"
                        },
                        "memuse": {
                          "type": "long"
                        },
                        "tcp": {
                          "type": "long"
                        },
                        "udp": {
                          "type": "long"
                        },
                        "tcp_reuse": {
                          "type": "long"
                        },
                        "icmpv4": {
                          "type": "long"
                        },
                        "emerg_mode_over": {
                          "type": "long"
                        },
                        "icmpv6": {
                          "type": "long"
                        },
                        "memcap": {
                          "type": "long"
                        },
                        "spare": {
                          "type": "long"
                        }
                      }
                    },
                    "uptime": {
                      "type": "long"
                    }
                  }
                },
                "flow_id": {
                  "type": "keyword"
                },
                "app_proto_expected": {
                  "type": "keyword"
                },
                "fileinfo": {
                  "type": "object",
                  "properties": {
                    "sha1": {
                      "type": "keyword"
                    },
                    "sha256": {
                      "type": "keyword"
                    },
                    "stored": {
                      "type": "boolean"
                    },
                    "state": {
                      "type": "keyword"
                    },
                    "tx_id": {
                      "type": "long"
                    },
                    "gaps": {
                      "type": "boolean"
                    },
                    "md5": {
                      "type": "keyword"
                    }
                  }
                },
                "http": {
                  "type": "object",
                  "properties": {
                    "redirect": {
                      "type": "keyword"
                    },
                    "protocol": {
                      "type": "keyword"
                    },
                    "http_content_type": {
                      "type": "keyword"
                    },
                    "content_range": {
                      "type": "object",
                      "properties": {
                        "size": {
                          "type": "long"
                        },
                        "start": {
                          "type": "long"
                        },
                        "raw": {
                          "type": "text"
                        },
                        "end": {
                          "type": "long"
                        }
                      }
                    }
                  }
                },
                "icmp_code": {
                  "type": "long"
                },
                "tls": {
                  "type": "object",
                  "properties": {
                    "string": {
                      "type": "keyword"
                    },
                    "notbefore": {
                      "type": "date"
                    },
                    "issuerdn": {
                      "type": "keyword"
                    },
                    "ja3s": {
                      "type": "object",
                      "properties": {
                        "string": {
                          "type": "keyword"
                        },
                        "hash": {
                          "type": "keyword"
                        }
                      }
                    },
                    "subject": {
                      "type": "keyword"
                    },
                    "notafter": {
                      "type": "date"
                    },
                    "session_resumed": {
                      "type": "keyword"
                    },
                    "version": {
                      "type": "keyword"
                    },
                    "sni": {
                      "type": "keyword"
                    },
                    "serial": {
                      "type": "keyword"
                    },
                    "fingerprint": {
                      "type": "keyword"
                    },
                    "ja3": {
                      "type": "object"
                    },
                    "hash": {
                      "type": "keyword"
                    }
                  }
                },
                "app_proto_ts": {
                  "type": "keyword"
                },
                "email": {
                  "type": "object",
                  "properties": {
                    "status": {
                      "type": "keyword"
                    }
                  }
                },
                "flow": {
                  "type": "object",
                  "properties": {
                    "reason": {
                      "type": "keyword"
                    },
                    "alerted": {
                      "type": "boolean"
                    },
                    "end": {
                      "type": "date"
                    },
                    "state": {
                      "type": "keyword"
                    },
                    "age": {
                      "type": "long"
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  },
  "index_patterns": [
    "*-pfelk-suricata*"
  ],
  "data_stream": {
    "hidden": false
  },
  "composed_of": [
    "pfelk-settings",
    "pfelk-mappings-ecs"
  ],
  "_meta": {
    "managed": true,
    "description": "default suricata indexes installed by pfelk"
  }
}
'
curl -X PUT "localhost:9200/_index_template/pfelk-nginx?pretty" -H 'Content-Type: application/json' -d'
{
  "version": 22,
  "priority": 56,
  "template": {
    "settings": {
      "index": {
        "lifecycle": {
          "name": "pfelk"
        }
      }
    },
    "mappings": {
      "dynamic": true,
      "numeric_detection": false,
      "date_detection": false,
      "_source": {
        "enabled": true,
        "includes": [],
        "excludes": []
      },
      "_routing": {
        "required": false
      },
      "dynamic_templates": [],
      "properties": {
        "nginx": {
          "type": "object",
          "properties": {
            "access": {
              "type": "object",
              "properties": {
                "agent": {
                  "type": "keyword"
                },
                "body_sent": {
                  "type": "object",
                  "properties": {
                    "bytes": {
                      "type": "long"
                    }
                  }
                },
                "geoip": {
                  "dynamic": true,
                  "type": "object",
                  "enabled": true,
                  "properties": {
                    "city_name": {
                      "type": "keyword"
                    },
                    "continent_name": {
                      "type": "keyword"
                    },
                    "country_iso_code": {
                      "type": "keyword"
                    },
                    "location": {
                      "type": "geo_point"
                    },
                    "region_iso_code": {
                      "type": "keyword"
                    },
                    "region_name": {
                      "type": "keyword"
                    }
                  }
                },
                "http_version": {
                  "type": "keyword"
                },
                "method": {
                  "type": "keyword"
                },
                "referrer": {
                  "type": "keyword"
                },
                "remote_ip_list": {
                  "index": true,
                  "store": false,
                  "type": "ip",
                  "doc_values": true
                },
                "response_code": {
                  "type": "long"
                },
                "url": {
                  "type": "wildcard"
                },
                "user_agent": {
                  "type": "object",
                  "properties": {
                    "device": {
                      "type": "keyword"
                    },
                    "name": {
                      "type": "keyword"
                    },
                    "original": {
                      "type": "keyword"
                    },
                    "os": {
                      "type": "keyword"
                    },
                    "os_name": {
                      "type": "keyword"
                    }
                  }
                },
                "user_name": {
                  "type": "keyword"
                }
              }
            },
            "error": {
              "type": "object",
              "properties": {
                "connection_id": {
                  "type": "long"
                },
                "level": {
                  "type": "keyword"
                },
                "message": {
                  "type": "text"
                },
                "process": {
                  "type": "long"
                },
                "tid": {
                  "type": "long"
                }
              }
            },
            "ingress_controller": {
              "type": "object",
              "properties": {
                "agent": {
                  "type": "keyword"
                },
                "body_sent": {
                  "type": "object",
                  "properties": {
                    "bytes": {
                      "type": "long"
                    }
                  }
                },
                "geoip": {
                  "type": "object",
                  "properties": {
                    "city_name": {
                      "type": "keyword"
                    },
                    "continent_name": {
                      "type": "keyword"
                    },
                    "country_iso_code": {
                      "type": "keyword"
                    },
                    "location": {
                      "type": "geo_point"
                    },
                    "region_iso_code": {
                      "type": "keyword"
                    },
                    "region_name": {
                      "type": "keyword"
                    }
                  }
                },
                "http": {
                  "type": "object",
                  "properties": {
                    "request": {
                      "type": "object",
                      "properties": {
                        "id": {
                          "type": "keyword"
                        },
                        "length": {
                          "type": "long"
                        },
                        "time": {
                          "type": "double"
                        }
                      }
                    }
                  }
                },
                "http_version": {
                  "type": "keyword"
                },
                "method": {
                  "type": "keyword"
                },
                "referrer": {
                  "type": "keyword"
                },
                "remote_ip_list": {
                  "eager_global_ordinals": false,
                  "norms": false,
                  "index": true,
                  "store": false,
                  "type": "keyword",
                  "index_options": "docs",
                  "split_queries_on_whitespace": false,
                  "doc_values": true
                },
                "response_code": {
                  "type": "long"
                },
                "upstream": {
                  "type": "object",
                  "properties": {
                    "alternative_name": {
                      "type": "keyword"
                    },
                    "ip": {
                      "type": "ip"
                    },
                    "name": {
                      "type": "keyword"
                    },
                    "port": {
                      "type": "long"
                    },
                    "response": {
                      "type": "object",
                      "properties": {
                        "length": {
                          "type": "long"
                        },
                        "length_list": {
                          "type": "keyword"
                        },
                        "status_code": {
                          "type": "long"
                        },
                        "status_code_list": {
                          "type": "keyword"
                        },
                        "time": {
                          "coerce": true,
                          "index": true,
                          "ignore_malformed": false,
                          "store": false,
                          "type": "double",
                          "doc_values": true
                        },
                        "time_list": {
                          "type": "keyword"
                        }
                      }
                    }
                  }
                },
                "upstream_address_list": {
                  "type": "keyword"
                },
                "url": {
                  "type": "wildcard"
                },
                "user_agent": {
                  "type": "object",
                  "properties": {
                    "device": {
                      "type": "keyword"
                    },
                    "name": {
                      "type": "keyword"
                    },
                    "original": {
                      "type": "keyword"
                    },
                    "os": {
                      "type": "keyword"
                    },
                    "os_name": {
                      "type": "keyword"
                    }
                  }
                },
                "user_name": {
                  "type": "keyword"
                }
              }
            }
          }
        }
      }
    }
  },
  "index_patterns": [
    "*-pfelk-nginx*"
  ],
  "data_stream": {
    "hidden": false
  },
  "composed_of": [
    "pfelk-settings",
    "pfelk-mappings-ecs"
  ],
  "_meta": {
    "description": "default nginx indexes installed by pfelk",
    "managed": true
  }
}
'
