package masproject;


import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.JTextField;

import jason.asSyntax.ASSyntax;
import jason.asSyntax.Literal;
import jason.asSyntax.Structure;
import jason.asSyntax.parser.ParseException;
import jason.environment.Environment;

public class HelplineEnvironment extends Environment {

@Override
public void init(String[] args) {
new MyWindow();

try {
this.addPercept(ASSyntax.parseLiteral("doctor(emma)"));
//this.addPercept(ASSyntax.parseLiteral("doctor(dave)"));
} catch (ParseException e) {
e.printStackTrace();
}
}

@Override
public boolean executeAction(String agName, Structure act) {
try {
Structure leave = ASSyntax.parseStructure("leave");
if(act.equals(leave)) {
this.addPercept(ASSyntax.parseLiteral("leaving(" + agName + ")"));
return true;
}
} catch (ParseException e1) {
e1.printStackTrace();
}
return false;
}

class MyWindow {

JTextField agentTextfield;
JTextField perceptTextfield;
JButton button;

public MyWindow() {
agentTextfield = new JTextField("anna", 15);
perceptTextfield = new JTextField("query(symptoms)", 15);

button = new JButton("Add");
button.addActionListener(new ActionListener() {
public void actionPerformed(ActionEvent e) {
try {
String agent = agentTextfield.getText();
Literal percept = ASSyntax.parseLiteral(perceptTextfield.getText());

addPercept(agent, percept);
} catch (ParseException e1) {
e1.printStackTrace();
}
}
});

JPanel panel = new JPanel();
panel.add(agentTextfield);
panel.add(perceptTextfield);
panel.add(button);

JFrame frame = new JFrame("Add percept");
frame.getContentPane().add(panel);
frame.pack();
frame.setVisible(true);
}

}

}