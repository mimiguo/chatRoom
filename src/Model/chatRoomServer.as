application.onAppStart = function() 
{
	trace(this.name+" is reloaded");
	this.users_so = SharedObject.get("videoChat", false); 
};
application.onConnect = function(currentClient, username) 
{
	trace(currentClient, username);
	currentClient.name = username;
	this.acceptConnection(currentClient);
	//this.users_so.setProperty(currentClient.name, username);
	//trace( this.users_so.getProperty(currentClient.name));
};
application.onDisconnect = function(currentClient) 
{
	trace("disconnect: "+currentClient.name);
	//this.users_so.setProperty(currentClient.name, null); 
};
