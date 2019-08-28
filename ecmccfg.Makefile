#
#  Copyright (c) 2019  European Spallation Source ERIC
#
#  The program is free software: you can redistribute
#  it and/or modify it under the terms of the GNU General Public License
#  as published by the Free Software Foundation, either version 2 of the
#  License, or any newer version.
#
#  This program is distributed in the hope that it will be useful, but WITHOUT
#  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
#  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
#  more details.
#
#  You should have received a copy of the GNU General Public License along with
#  this program. If not, see https://www.gnu.org/licenses/gpl-2.0.txt
#
# 
# Author  : Jeong Han Lee
# email   : jeonghan.lee@gmail.com
# Date    : Monday, August 26 14:22:52 CEST 2019
# version : 0.0.1
#
## The following lines are mandatory, please don't change them.
where_am_I := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
include $(E3_REQUIRE_TOOLS)/driver.makefile
include $(E3_REQUIRE_CONFIG)/DECOUPLE_FLAGS



## We exclude this for the following arch,
## but we may need them later
##
EXCLUDE_ARCHS = linux-ppc64e6500
EXCLUDE_ARCHS += linux-corei7-poky

APP:=.
APPDB:=$(APP)/db
APPSCRIPTS:=$(APP)/scripts

# https://github.com/icshwi/ECMC_config/issues/1
# We only install "db" files into the installation location
# Monday, August 26 14:01:12 CEST 2019, jhlee

TEMPLATES += $(wildcard $(APPDB)/*.db)


SCRIPTS += $(APP)/startup.cmd
SCRIPTS += $(APPSCRIPTS)/addMaster.cmd
SCRIPTS += $(APPSCRIPTS)/addSlave.cmd
SCRIPTS += $(APPSCRIPTS)/configureSlave.cmd
SCRIPTS += $(APPSCRIPTS)/applyConfig.cmd
SCRIPTS += $(APPSCRIPTS)/setAppMode.cmd
SCRIPTS += $(APPSCRIPTS)/addAxis.cmd
SCRIPTS += $(APPSCRIPTS)/addVirtualAxis.cmd
SCRIPTS += $(APPSCRIPTS)/configureAxis.cmd
SCRIPTS += $(APPSCRIPTS)/configureVirtualAxis.cmd
SCRIPTS += $(APPSCRIPTS)/applyAxisSynchronization.cmd
SCRIPTS += $(APPSCRIPTS)/loadPLCFile.cmd

SCRIPTS += $(wildcard $(APP)/general/*.cmd)
SCRIPTS += $(wildcard $(APP)/hardware/*.cmd)
SCRIPTS += $(wildcard $(APP)/motion/*.cmd)
SCRIPTS += $(wildcard $(APP)/protocol/*.cmd)


SCRIPTS += $(wildcard ../iocsh/*.iocsh)


## This RULE should be used in case of inflating DB files 
## db rule is the default in RULES_DB, so add the empty one
## Please look at e3-mrfioc2 for example.

USR_DBFLAGS += -I . -I ..
USR_DBFLAGS += -I $(EPICS_BASE)/db
USR_DBFLAGS += -I $(APPDB)

SUBS=$(wildcard $(APPDB)/*.substitutions)


db: $(SUBS) 

$(SUBS):
	@printf "Inflating database ... %44s >>> %40s \n" "$@" "$(basename $(@)).db"
	@rm -f  $(basename $(@)).db.d  $(basename $(@)).db
	@$(MSI) -D $(USR_DBFLAGS) -o $(basename $(@)).db -S $@  > $(basename $(@)).db.d
	@$(MSI)    $(USR_DBFLAGS) -o $(basename $(@)).db -S $@


.PHONY: db $(SUBS)


vlibs:

.PHONY: vlibs

