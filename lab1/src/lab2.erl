%% @author Alena
%% @doc @todo Add description to lab2.


-module(lab2).

%% ====================================================================
%% API functions
%% ====================================================================
-export([main/0, firm/0, client/2, bank/0, truckProvider/0, receiverClient/0]).


firm()->
	
	receive
		done->
			io:format("Firm: done~n");
		orderRequest->
			io:format("Firm: new client! new invoice~n"),
			pidClient!invoice,
			firm();
		paymentReceived->
			io:format("Firm: payment recieved!~n"),
			pidClient!cargoRequest,
			firm();
		cargoToFirm->
			io:format("Firm: ordering truck!~n"),
			pidTruckProvider!truckRequest,
			firm();
		truckFound->
			io:format("Firm: truck found, sending!~n"),
			pidTruckProvider!cargoToProvider,
			firm();
		orderFinished->
			io:format("Firm: well done!!!~n"),
			firm()
	end.

client(0,_)->
	io:format("Client: finally done!~n"),
	pidFirm!done,
	pidBank!done,
	pidTruckProvider!done,
	pidReceiverClient!done;

client(Index,0)->
		io:format("Client: new client!~n"),
		pidFirm!orderRequest,
		client(Index,1);

client(Index,1)->		
	receive
		invoice->
			io:format("Client: invoice received, ready to pay~n"),
			pidBank!payment,
			client(Index,1);
		cargoRequest->	
			io:format("Client: sending cargo to firm~n"),
			pidFirm!cargoToFirm,
			client(Index,1);
		jobDone->
			io:format("Client: order complete~n"),
			client(Index-1,0)
	end.


bank()->
	receive
		done->
			io:format("Bank: done~n");
		payment->
			io:format("Bank: payment received, send message to firm~n"),
			pidFirm!paymentReceived			
	end,
bank().

truckProvider()->
	receive
		done->
			io:format("Provider: done~n");
		truckRequest->
			io:format("Provider: looking for a truck... done!~n"),
			pidFirm!truckFound,
			truckProvider();
		cargoToProvider->
			io:format("Provider: cargo received, truck sent~n"),
			pidReceiverClient!cargoDone,
			truckProvider()
	end.


receiverClient()->
	receive
		done->
			io:format("Receiver: done~n");
		cargoDone->
			io:format("Receiver: it's here!!!~n"),
			pidClient!jobDone,
			pidFirm!orderFinished,
			receiverClient()
	end.



main()->
	io:format("WELCOME TO TRUCKING INDUSTRY!!!~n"),
	register(pidFirm,spawn(lab2,firm,[])),
	register(pidClient,spawn(lab2,client,[5,0])),
	register(pidBank,spawn(lab2,bank,[])),
	register(pidTruckProvider,spawn(lab2, truckProvider,[])),
	register(pidReceiverClient,spawn(lab2, receiverClient,[])).


		
%% ====================================================================
%% Internal functions
%% ====================================================================


