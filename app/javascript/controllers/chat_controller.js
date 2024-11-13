import {Controller} from "@hotwired/stimulus"
import consumer from "channels/consumer";

// Connects to data-controller="chat"
export default class extends Controller {
    static targets = ["textinput", "messagesContainer", "noMessage", "overlay", "editMessage", "textinputEdit", "closeEditBtn"]

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
                    if(data.method === 'create') {
                        if (data.message.sender_id.toString() === senderId) {
                            messages.insertAdjacentHTML("beforeend",
                                `<div id="message_${data.message.id}" class="message-container sender">
                                        <div class="more-options-message">
                                          <button class="more-options-message-button">...</button>
                                          <ul class="more-options">
                                            <li class="item-option">
                                                <a href="">Edit</a>
                                            </li>
                                            <li class="item-option">
                                                <a data-turbo-method="delete" data-turbo-confirm="You sure?" href="/users/${data.message.recipient_id}/messages/${data.message.id}">Delete</a>
                                            </li>
                                          </ul>
                                        </div>
                                      <span class="message sender">${data.message.content}</span>
                                    </div>`)
                        } else {
                            messages.insertAdjacentHTML("beforeend",
                                `<div id="message_${data.message.id}" class="message-container">
                                        <span class="message">${data.message.content}</span>
                                   </div>`)
                        }
                        if(messages.children.length > 0) {
                            noMes.style.display = 'none'
                        } else {
                            noMes.style.display = 'block'
                        }
                    }
                    if(data.method === 'update') {
                        const updatedMessage = document.querySelector(`#message_${data.message.id} .message`)
                        updatedMessage.textContent = data.message.content
                        console.log(updatedMessage)
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

    openOverlay(event) {
        const messageId = event.target.getAttribute("data-message-id");
        console.log(messageId)
        const overlay = document.getElementById(`overlay_${messageId}`)
        console.log(overlay.style.display)
        if (!overlay.style.display || overlay.style.display === 'none') {
            overlay.style.display = 'flex'
        } else {
            overlay.style.display = 'none'
        }
    }

    closeOverlay(event) {
        const messageId = event.target.getAttribute("data-message-id");
        console.log(messageId)
        const overlay = this.overlayTarget
        overlay.style.display = 'none'
    }

    clearTextInputEdit(event){
        if (event.detail.success) {

            this.textinputEditTarget.value = '';
        }
    }

}
