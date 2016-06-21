package main.java;

import javax.ejb.EJB;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.ViewScoped;
import java.io.Serializable;
import database.Database;
import database.Row;
import org.primefaces.event.SelectEvent;
import org.primefaces.event.UnselectEvent;
import javax.faces.event.ActionEvent;
import javax.faces.event.AjaxBehaviorEvent;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import java.util.ArrayList;
import java.util.Hashtable;

@ManagedBean(name = "CurrencyConverter")
@ViewScoped
public class CurrencyConverterBean implements Serializable{
    /**
     * Private fields
     */
    private static final String EJB_NAME = "java:comp/env/DatabaseBean";
    private Row selected = new Row("", "", 0, "", "", 0.0);
    private ArrayList<Row> data = null;
    private Integer code;
    private String name = "";
    private Double input = 0.00;
    private Double output = 0.00;
    @EJB(name="DatabaseBean")
    private Database db;

    /**
     * Constructors
     */
    public CurrencyConverterBean(){
        try{
            if(this.db == null){
                Hashtable hash = new Hashtable();
                InitialContext context = new InitialContext(hash);
                this.db = (Database)context.lookup(EJB_NAME);
                this.fill();
            }
        }
        catch(NamingException E){
            System.err.println("Naming exception: " + E.getLocalizedMessage());
        }
    }

    /**
     * Getters
     */
    public Row getSelected(){
        return this.selected;
    }
    public ArrayList<Row> getData(){
        return this.data;
    }
    public Integer getCode(){
        return this.code;
    }
    public String getName(){
        return this.name;
    }
    public Double getInput(){
        return this.input;
    }
    public Double getOutput(){
        return this.output;
    }

    /**
     * Setters
     */
    public void setSelected(Row value){
        this.selected = value;
    }
    public void setData(ArrayList<Row> value){
        this.data.clear();
        this.data = value;
    }
    public void setCode(Integer value){
        this.code = value;
    }
    public void setName(String value){
        this.name = value;
    }
    public void setInput(Double value){
        this.input = value;
    }
    public void setOutput(Double value){
        this.output = value;
    }

    /**
     * Action callbacks
     */
    public void convert(AjaxBehaviorEvent event){
        this.converting();
    }
    public void select(SelectEvent event){
        this.converting();
    }
    public void unselect(UnselectEvent event){
        this.converting();
    }
    public void filter(ActionEvent event){
        this.fill();
    }


    /**
     * Private methods
     */
    private void fill(){
        if(this.data != null){
            this.data.clear();
        }
        this.data = (ArrayList<Row>)this.db.execute(this.code, this.name);
    }
    private void converting(){
        if(this.input.isNaN()){
            this.output = 0.00;
        }
        else if(!this.isSelectedValid()){
            this.output = this.input;
        }
        else{
            this.output = this.input * this.selected.getRate();
        }
    }
    private boolean isSelectedValid(){
        if(this.selected == null){
            return false;
        }
        if(this.selected.getCode() == null ||
                this.selected.getCode() <= 0){
            return false;
        }
        if(this.selected.getRate().isNaN() ||
                this.selected.getRate() <= 0.0){
            return false;
        }
        return true;
    }
}
