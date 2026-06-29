import { LightningElement } from 'lwc';
export default class Calculator extends LightningElement {
    firstnum = 0;
    secondnum = 0;
    result = 0;
    handleNum1(event) {
        this.firstnum = Number(event.target.value);
    }
    handleNum2(event) {
        this.secondnum = Number(event.target.value);
    }
    add() {
        this.result = this.firstnum + this.secondnum;
    }
    Subtract() {
        this.result = this.firstnum - this.secondnum;
    }
    Multiply() {
        this.result = this.firstnum * this.secondnum;
    }
    Divide() {
        if (this.secondnum === 0) {
            this.result = 'cannot divide by zero';
        } else {
            this.result = this.firstnum / this.secondnum;
        }
    }
}