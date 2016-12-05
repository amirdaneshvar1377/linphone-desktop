import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

import Common 1.0
import Linphone 1.0
import LinphoneUtils 1.0
import Utils 1.0

import App.Styles 1.0

// ===================================================================

ColumnLayout  {
  id: contactEdit

  property string sipAddress: ''

  property var _contact: ContactsListModel.mapSipAddressToContact(
    sipAddress
  ) || sipAddress

  // -----------------------------------------------------------------

  function _removeContact () {
    Utils.openConfirmDialog(this, {
      descriptionText: qsTr('removeContactDescription'),
      exitHandler: function (status) {
        if (status) {
          ContactsListModel.removeContact(_contact)
          window.setView('Home')
        }
      },
      title: qsTr('removeContactTitle')
    })
  }

  // -----------------------------------------------------------------

  spacing: 0

  // -----------------------------------------------------------------
  // Info bar.
  // -----------------------------------------------------------------

  Rectangle {
    Layout.fillWidth: true
    Layout.preferredHeight: ContactEditStyle.infoBar.height
    color: ContactEditStyle.infoBar.color

    RowLayout {
      anchors {
        fill: parent
        leftMargin: ContactEditStyle.infoBar.leftMargin
        rightMargin: ContactEditStyle.infoBar.rightMargin
      }

      spacing: ContactEditStyle.infoBar.spacing

      Avatar {
        id: avatar

        height: ContactEditStyle.infoBar.avatarSize
        width: ContactEditStyle.infoBar.avatarSize

        username: LinphoneUtils.getContactUsername(_contact)
      }

      Text {
        Layout.fillWidth: true
        color: ContactEditStyle.infoBar.username.color
        elide: Text.ElideRight

        font {
          bold: true
          pointSize: ContactEditStyle.infoBar.username.fontSize
        }

        text: avatar.username
      }

      ActionBar {
        Layout.alignment: Qt.AlignRight
        iconSize: ContactEditStyle.infoBar.buttons.size
        spacing: ContactEditStyle.infoBar.buttons.spacing

        ActionButton {
          icon: 'history'
          onClicked: window.setView('Conversation', {
            sipAddress: contactEdit.sipAddress
          })
        }

        ActionButton {
          icon: 'delete'
          onClicked: _removeContact()
        }
      }
    }
  }

  // -----------------------------------------------------------------
  // Info list.
  // -----------------------------------------------------------------

  Flickable {
    Layout.fillHeight: true
    Layout.fillWidth: true
    ScrollBar.vertical: ForceScrollBar {}
    boundsBehavior: Flickable.StopAtBounds
    clip: true
    contentHeight: content.height
    flickableDirection: Flickable.VerticalFlick

    ColumnLayout {
      anchors.left: parent.left
      anchors.margins: 20
      anchors.right: parent.right
      id: content

      ListForm {
        title: qsTr('sipAccounts')
        model: ListModel {
          ListElement { $value: 'merinos@sip.linphone.org' }
          ListElement { $value: 'elisabeth.pro@sip.linphone.org' }
        }
        placeholder: qsTr('sipAccountsInput')
      }

      ListForm {
        title: qsTr('address')
        model: ListModel {
          ListElement { $value: '312 East 10th Street - New York, NY 1009' }
        }
        placeholder: qsTr('addressInput')
      }

      ListForm {
        title: qsTr('emails')
        model: ListModel {
          ListElement { $value: 'e.meri@gmail.com' }
          ListElement { $value: 'toto@truc.machin' }
        }
        placeholder: qsTr('emailsInput')
      }

      ListForm {
        title: qsTr('webSites')
        model: ListModel {
          ListElement { $value: 'www.totogro.com' }
          ListElement { $value: 'www.404.unknown' }
        }
        placeholder: qsTr('webSitesInput')
      }
    }
  }
}