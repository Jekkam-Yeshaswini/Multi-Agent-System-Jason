// Agent patient in project masproject

/* Initial beliefs and rules */

// 3 agents were introduced so that the variations of each of their beliefs about their symptoms can yield different results from the doctor agent.


has (anna,cough).
~has (anna,cold).
has (anna,high_fever).
has (anna,diarrea).

~has (elsa,cough).
~has (elsa,cold).
has (elsa,high_fever).
~has (elsa,diarrea).

~has (john,cough).
~has (john,cold).
~has (john,high_fever).
~has (john,diarrea).

 /* Initial goals */


 /* Plans */
// The main goal of the patient agent is to get a diagnosis. Hence the following acheivement (sub)Goal is responsible to communicate that to the agent doctor.
 +!diagnose(X) 
 	: doctor(Y) & query(X) // in the environment created, every agent is able to perceive the doctor agent as a doctor. 
 			<- .print(Y, ", I would like a diagnosis with covid ", X); 
 			.send(Y, tell, want_questioniare(X)). //sends a communication to the doctor that initiates the diagnosis by asking questions.
 +!diagnose(X) 
 	: true 
 		<- .print("it looks like help regarding your query about ", X, " is currently unavailable").
 			

+?cough(X)[source(Y)]: has(X,cough) <- .print("Yes, I have cough"); .send(Y, tell, yes_cough(X)).
+?cough(X)[source(Y)]: not has(X,cough) <- .print("No, I do not have cough"); .send(Y, tell, no_cough(X)).

+?high_fever(X)[source(Y)]: has(X,high_fever) <- .print("Yes, I have high fever"); .send(Y, tell, yes_high_fever(X)).
+?high_fever(X)[source(Y)]: not has(X,high_fever) <- .print("No, I do not have high fever"); .send(Y, tell, no_high_fever(X)).

+?diarrea(X)[source(Y)]: has(X,diarrea) <- .print("Yes, I have diarrea"); .send(Y, tell, yes_diarrea(X));.send(Y, tell, final_diagnosis(X)).
+?diarrea(X)[source(Y)]: not has(X,diarrea) <- .print("No, I do not have diarrea"); .send(Y, tell, no_diarrea(X));.send(Y, tell, final_diagnosis(X)).


// When the diagnosis is declared as completed, the patient agent ends the conversation. and leaves.
 +complete(diagnosis)[source(Y)] 
 	: true 
 	<- .print(Y, ", thank you very much. I will do as you suggested"); 
 	.print("Goodbye ",Y);
	leave. // this action is implemented in the environment that passes a belief that this agent is leaving.

 +leaving(X) : .my_name(X) <- .kill_agent(X). //upon receiving that belief, in the context of whether the leaving agent is the same as self, then the agent kills self.

//This is a belief that's under the control of the user. Which can be added through the window created to initiate the diagnosis of the patient agent that is passed through the percept
 +query(X) : true <- !diagnose(X).

