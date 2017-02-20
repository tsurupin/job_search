import React, { PropTypes, Component } from 'react';
import styles from './styles.css';
import {
  HeaderContainer,
  JobShowContainer
} from 'containers';

const propTypes = {

};

class JobShowPage extends Component {

  constructor(props) {
    super(props)
  }

  render() {
    return (
      <div className={styles.container}>
        <HeaderContainer />
        <JobShowContainer id={this.props.params.id} />
      </div>
    )
  }

}

JobShowPage.propTypes = propTypes;
export default JobShowPage;
