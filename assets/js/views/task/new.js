export default class NewTaskForm {
  handleDOMContentLoaded () {
    const btnAddCommand = document.getElementById('add-command')
    if (btnAddCommand) {
      btnAddCommand.addEventListener('click', this.onAddCommand, false)
    }

    const btnAddEnv = document.getElementById('add-env')
    if (btnAddEnv) {
      btnAddEnv.addEventListener('click', this.onAddEnv.bind(this), false)
    }
  }

  onAddCommand (event) {
    event.preventDefault()

    const commandGroup = document.querySelector('[data-commands-group]')
    const input = document.createElement('input')
    input.className = 'form-control'
    input.name = 'task[commands][]'
    input.type = 'text'
    commandGroup.appendChild(input)
  }

  onAddEnv (event) {
    event.preventDefault()

    const envGroup = document.querySelector('[data-env-group]')
    const [newEnvInput] = document.getElementsByName('new-env')
    const key = newEnvInput.value

    const keyInput = document.createElement('input')
    keyInput.className = 'form-control'
    keyInput.name = `task[env][${key}]`
    keyInput.type = 'text'

    const inputLabel = document.createElement('label')
    inputLabel.setAttribute('for', keyInput.name)
    inputLabel.innerHTML = key

    const deleteEnvLink = document.createElement('a')
    deleteEnvLink.innerHTML = 'X'
    deleteEnvLink.onclick = this.onDeleteEnv(inputLabel, keyInput)

    envGroup.appendChild(inputLabel)
    envGroup.appendChild(keyInput)
    envGroup.appendChild(deleteEnvLink)

    newEnvInput.value = ''
  }

  onDeleteEnv (inputLabel, keyInput) {
    return function (event) {
      event.preventDefault()
      inputLabel.parentNode.removeChild(inputLabel)
      keyInput.parentNode.removeChild(keyInput)
      this.parentNode.removeChild(this)
    }
  }
}

const form = new NewTaskForm()

window.addEventListener('DOMContentLoaded', form.handleDOMContentLoaded.bind(form), false)
