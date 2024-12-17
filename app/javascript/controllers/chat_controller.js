import {Controller} from "@hotwired/stimulus"
import consumer from "channels/consumer";

// Connects to data-controller="chat"
export default class extends Controller {
    static targets = ["textinput", "messagesContainer", "noMessage", "overlay", "editMessage", "textinputEdit", "closeEditBtn"]

    connect() {
        this.sub = this.createActionCableChannel();
        $(document).ready(this.verifyImageInput())
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
            if (data.message.data.sender_id.toString() === senderId) {
                messages.insertAdjacentHTML("beforeend", data.message.sender_message)
            } else {
                messages.insertAdjacentHTML("beforeend", data.message.recipient_message)
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
                            break
                        case "error":
                            alert(data.message)
                    }
                },
            }
        );
    }

    async sendMessage(event) {
        event.preventDefault()
        const content = this.textinputTarget.value
        const image = $("#message-image-input")
        const arrayUrl = document.URL.split('/').at(-2)
        if(image[0].files[0] !== undefined) {
            const file = image[0].files[0]
            const formData = new FormData()
            formData.append("content", "send image")
            formData.append("image", file)
            const response = await fetch(document.URL, {
                method: "POST",
                headers: {
                    'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
                    "Content-Type": "multipart/form-data"
                },
                body: formData
            });
            console.log(arrayUrl, response)
        } else {
            console.log("sent text")
            this.sub.perform("create", {message: content})
        }
        this.textinputTarget.value = '';
        image.val("")
        $("#preview-image-input").addClass("hidden");
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

    verifyImageInput() {
        $("#message-image-input").bind("change", function () {
            const size_in_megabytes = this.files[0].size / 1024;
            console.log(this.files[0])
            const url = URL.createObjectURL(this.files[0])
            if (size_in_megabytes > 200) {
                alert("Maximum file size is 200 KB. Please choose a smaller file.");
                $("#message-image-input").val("");
            }
            $("#preview-image-input").removeClass("hidden").attr("src",url);
        })
    }

}
