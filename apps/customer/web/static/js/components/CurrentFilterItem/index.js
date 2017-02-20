import React, { Component, PropTypes } from 'react';
import styles from './styles.css';
import { TECH_KEYWORD } from 'constants';

const propTypes = {
  name: PropTypes.string.isRequired,
  value: PropTypes.string.isRequired,
  handleReset: PropTypes.func.isRequired,
  handleResetTechKeyword: PropTypes.func.isRequired
};

class CurrentFilterItem extends Component {
  constructor(props) {
    super(props);
    this.handleReset = this.handleReset.bind(this);
  }

  handleReset() {
    const {
      name,
      value,
      handleReset,
      handleResetTechKeyword
    } = this.props;
    if (name === TECH_KEYWORD) return handleResetTechKeyword(name, value);
    handleReset(name);
  }

  render() {
    const { value } = this.props;
    return (
      <div className={styles.root}>
        <p className={styles.deleteIcon} onClick={this.handleReset} >Delete</p>
        <p className={styles.text}>{value}</p>
      </div>
    )
  }

}

CurrentFilterItem.propTypes = propTypes;
export default CurrentFilterItem;