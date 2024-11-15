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

        function printNewMessage(data) {
            if (data.message.sender_id.toString() === senderId) {
                messages.insertAdjacentHTML("beforeend",
                    `<div id="message_${data.message.id}" class="message-container sender">
                            <div class="message-container-sender">
                                <div class="overlay" data-chat-target="overlay" id="overlay_${data.message.id}">
                                  <div id="message_edit_${data.message.id}" class="edit-message-container">
                                    <div class="header-edit">
                                      <span class="icon-close" data-chat-target="closeEditBtn">
                                        <i class="fa-solid fa-xmark" data-message-id="${data.message.id}" data-action="click->chat#openOverlay">
                                        </i>
                                      </span>
                                    </div>
                                    <form class="message-form-container" data-message-id="${data.message.id}" data-action="submit->chat#updateMessage"
                                            accept-charset="UTF-8" method="post">
                                          <input type="hidden" name="_method" value="put" autocomplete="off">
                                          <input type="hidden" name="authenticity_token" value="RZ-260Qv6bibBOdYHHTvTn49VAwii2A-42na9TXiRTWmH1JUhV-ra3VTzLWWWKDDQ3Z72o19CQciwBU9rfvwyA"
                                          autocomplete="off">
                                          <input value="${data.message.content}" name="content" placeholder="Chat here..."
                                          class="message-form-input" id="edit_input_${data.message.id}" data-chat-target="textinputEdit" type="text"
                                          id="content">
                                          <input type="submit" name="commit" value="Edit" class="comment-button message-form-submit"
                                          data-disable-with="Edit">
                                    </form>
                                  </div>
                                </div>
                                <div class="more-options-message">
                                  <button class="more-options-message-button">...</button>
                                  <ul class="more-options">
                                    <li class="item-option" data-chat-target="editMessage" data-message-id="${data.message.id}" data-action="click->chat#openOverlay">
                                      Edit
                                    </li>
                                    <li class="item-option">
                                        <a data-turbo-method="delete" data-turbo-confirm="You sure?" href="/users/${recipientUser}/messages/${data.message.id}">Delete</a>
                                    </li>
                                  </ul>
                                </div>
                                <span class="message sender">${data.message.content}</span>
                            </div>
                        </div>`
                )
            } else {
                messages.insertAdjacentHTML("beforeend",
                    `<div id="message_${data.message.id}" class="message-container">
                                <div class="message-body">
                                  <span class="message">
                                    ${data.message.content}
                                  </span>
                                </div>
                            </div>`)
            }
            if(messages.children.length > 0) {
                noMes.style.display = 'none'
            } else {
                noMes.style.display = 'block'
            }
        }

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
                    switch (data.method) {
                        case "create":
                            printNewMessage(data)
                            break
                        case "update":
                            const updatedMessage = document.querySelector(`#message_${data.message.id} .message`)
                            updatedMessage.textContent = data.message.content
                            const message = document.querySelector(`#message_${data.message.id}`)
                            const infoEditMessage = document.querySelector(`#message_${data.message.id} .info-edit-message`)
                            if (!infoEditMessage) {
                                message.insertAdjacentHTML("beforeend", `
                                    <div class="info-edit-message">
                                        Edited
                                    </div>
                                `
                                )
                            } else {
                                infoEditMessage.textContent = "Edited"
                            }

                            if (data.message.sender_id.toString() !== recipientUser) {
                                const overlay = document.getElementById(`overlay_${data.message.id}`)
                                overlay.style.display = 'none'
                            }
                            break;
                        case "delete":
                            const deletedMessage = document.querySelector(`#message_${data.message.id}`)
                            deletedMessage.remove()
                    }
                },
            }
        );
    }

    sendMessage(event) {
        event.preventDefault()
        const content = this.textinputTarget.value
        this.sub.perform("create", {message: content})
        this.textinputTarget.value = '';
    }

    updateMessage(event){
        event.preventDefault()
        const messageId = event.target.getAttribute("data-message-id");
        const editInput = document.getElementById(`edit_input_${messageId}`)
        this.sub.perform("update", {id: messageId, message: editInput.value})
    }

    deleteMessage(event) {
        event.preventDefault()
        const messageId = event.target.getAttribute("data-message-id");
        this.sub.perform("delete", {id: messageId})
    }

    openOverlay(event) {
        const messageId = event.target.getAttribute("data-message-id");
        const overlay = document.getElementById(`overlay_${messageId}`)
        if (!overlay.style || overlay.style.display === 'none') {
            overlay.style.display = 'flex'
        } else {
            overlay.style.display = 'none'
        }
    }

    closeOverlay(event) {
        const messageId = event.target.getAttribute("data-message-id");
        const overlay = this.overlayTarget
        overlay.style.display = 'none'
    }

}
