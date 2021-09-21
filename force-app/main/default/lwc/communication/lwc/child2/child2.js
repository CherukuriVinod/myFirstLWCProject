import { LightningElement } from "lwc";

export default class Child2 extends LightningElement {
  eventNumber = 0;
  copiedObject;
  eventObject = {
    num: 0,
    ename: ""
  };

  handleNameChange(event) {
    this.eventObject.ename = event.detail.value;
  }

  handleNumberChange(event) {
    //this.eventNumber = event.detail.value;
    this.eventObject.num = event.detail.value;
  }

  handleClick() {
    this.copiedObject = Object.assign({}, this.eventObject);
    this.dispatchEvent(
      new CustomEvent("clicked2", { detail: this.copiedObject })
    );
  }
}
