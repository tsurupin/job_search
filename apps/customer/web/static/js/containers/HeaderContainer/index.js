import React, { Component, PropTypes } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import * as HeaderActionCreators from './action';
import styles from './styles.css';

const propTypes = {

}

function mapStateToProps(response) {
  const { submitting, errorMessage } = response;
  return {
    submitting,
    errorMessage
  }
};

function mapDispatchToProps(dispatch) {
  return {
    actions: bindActionCreators(
      HeaderActionCreators,
      dispatch
    )
  }
};


class HeaderContainer extends Component {
  constructor(props) {
    super(props);

    this.state = {
      canSubmit: false
    }

  }

  handleLogout() {
    this.props.actions.logout();
  }

  // renderButton() {
  //   if (localStorage.getItem('accesssToken')) {
  //     return <a href='/api/v1/auth/google'>LogIn</button>
  //   } else {
  //     return <button type='submit' onClick={this.handleLogin}>Login</button>
  //   }
  // }

  render() {
    return (
       <a href='/auth/google?scope=email'>LogIn</a>
    )
  }
}

HeaderContainer.peropTypes = propTypes;
export default connect(mapStateToProps, mapDispatchToProps)(HeaderContainer);
