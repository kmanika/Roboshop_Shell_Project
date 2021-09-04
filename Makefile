help:		## Print this message
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$//' | sed -e 's/://' -e 's/##//'
frontend:	## Install frontend component
	@bash frontend.sh
catalogue:	## Install catalogue component
	@bash catalogue.sh
cart:		## Install cart component
	@bash cart.sh
user:		## Install user component
	@bash user.sh
shipping:	## Install shipping component
	@bash shipping.sh
payment:	## Install payment component
	@bash payment.sh
mongodb:	## Install mongodb component
	@bash mongodb.sh
mysql:	## Install mysql component
	@bash mysql.sh
redis:	## Install redis component
	@bash redis.sh
rabbitmq:	## Install rabbitmq component
	@bash rabbitmq.sh
databases:	## Installing  All Databases
databases:	mongodb redis mysql rabbitmq