import { LightningElement } from "lwc";

export default class Parent extends LightningElement {
  eventName;
  eventName2;

  handleButtonClicked2(event) {
    //this.eventName2 = 'Child2 Button Clicked: ' + event.detail;
    this.eventName2 =
      "Child2 Button Clicked: " + event.detail.ename + event.detail.num;
  }

  // eslint-disable-next-line no-unused-vars
  handleButtonClicked(event) {
    this.eventName = "Child Button Clicked";
  }
}
