// Agent doctor in project masproject

/* Initial beliefs and rules */
patient(X).

yes_virus(X) :- yes_cough(X) & yes_high_fever(X) & yes_diarrea(X). //Firstly, if all the symptoms are present then, the patient has virus
no_virus(X) :- no_cough(X) & no_high_fever(X) & no_diarrea(X). // If none of the symptoms are present then, patient does not have the virus
maybe_virus(X) :- no_cough(X) | no_high_fever(X) | no_diarrea(X). // if either one of the symptoms are present then, the patient may have the virus.

 /* Initial goals */
 
!answer(call). // to answer the call is the initial goal. This initiates the agent simulation of the crafter scenario.

 /* Plans */

// the call is answered in the context of whether or not the call is on-going. 
 +!answer(X) 
 	: not in_call(X) 
 		<- .print("Thank you for calling Coronavirus helpline. I have received a ", X, ". How may I assist you today?");
 		 +in_call(X).
 +!answer(X) :  in_call(X) <- .print("this line is busy. call later").
 
// the following event is responsible to converese with the patient agent to collect information of their symptoms
+want_questioniare(X)[source(Y)] 
	: true 
		<- .print("ok ", Y, ", I will now ask you a few questions about your symptoms that'll help me determine whether or not you have the coronavirus. ");
			.print("Have you been experiencing cough?");
		   .send(Y, askOne, cough(Y));
		   .print("Have you been experiencing high body temperature?");
		   .send(Y, askOne, high_fever(Y));
		   	.print("do you have an upset stomach?");
		   .send(Y, askOne, diarrea(Y));
		   .
		   
// When the final diagnosis is called for, each symptom is assessed in the contexts by checking the rules to determine whether or not the patient has the virus. Accordingly, there are some recommendations put in place.


+final_diagnosis(X) 
	:  yes_virus(X) //checks rule
		<- .print("You most likely to have the virus. You need to contact the emergency line on 999 for immediate support")
		.send(X, tell, complete(diagnosis)) //communicates that the diagnosis is complete to the patient.
		.
		
+final_diagnosis(X)[source(Y)] 
	: no_virus(X) //checks rule
		<- .print("You do not have the virus. You may continue with your life, complying to the government rules and regulations along with following the precautionary measures")
		.send(X, tell, complete(diagnosis)) //communicates that the diagnosis is complete to the patient.
		.

+final_diagnosis(X)[source(Y)] 
	: maybe_virus(X) // checks rule 
		<- .print("You may have the virus. According to the rules, you are required to self isolate for 2 weeks. Contact your GP via telephone for advice on how you can manage your symptoms. You can also book to get yourself tested if you need to.")
		.send(X, tell, complete(diagnosis)) //communicates that the diagnosis is complete to the patient.
		.
		   
 
// A behavior to leave is encorporated to kill the agent when the goal is accomplished. And is implemented as follows.
 +leaving(X) : .my_name(X) <- .kill_agent(X) .
 +leaving(X) : true <- .print("goodbye ", X, "! Glad to help."); -in_call(X); .print("               "). // At this point, when the patient agent leaves, the call is then declined. An additional empty print statement is added for convenience and better readability on the console between consecutive telephonic interactions with different patient agents.
  
