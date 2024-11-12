import {Controller} from "@hotwired/stimulus"
import consumer from "channels/consumer";

// Connects to data-controller="chat"
export default class extends Controller {
    static targets = ["textinput", "messagesContainer", "noMessage"]

    connect() {
        this.sub = this.createActionCableChannel();
    }

    checkMessages() {
        if(this.messagesContainerTarget.children.length > 0) {
            this.noMessageTarget.style.display = 'none'
        } else {
            this.noMessageTarget.style.display = 'block'
        }
    }

    createActionCableChannel() {
        const messages = this.element.querySelector("#messages-container")
        const senderId = this.element.dataset.currentUserId
        const recipientUser = this.element.dataset.recipientUserId
        const noMes = this.noMessageTarget
        return consumer.subscriptions.create(
            {channel: "ChatChannel", user_id: recipientUser},
            {
                connected() {
                    console.log("Connected to the chat channel");
                },

                disconnected() {
                    console.log("Connected to the chat channel");
                },

                received(data) {
                    if (data.message.sender_id.toString() === senderId) {
                        messages.insertAdjacentHTML("beforeend",
                            `<div class="message-container sender"><span class="message sender">${data.message.content}</span></div>`)
                    } else {
                        messages.insertAdjacentHTML("beforeend",
                            `<div class="message-container"><span class="message">${data.message.content}</span></div>`)
                    }
                    if(messages.children.length > 0) {
                        noMes.style.display = 'none'
                    } else {
                        noMes.style.display = 'block'
                    }
                },
            }
        );
    }

    clearTextInput(event) {
        if (event.detail.success) {
            this.textinputTarget.value = '';
        }
    }
}
