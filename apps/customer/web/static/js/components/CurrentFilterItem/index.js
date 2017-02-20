import React, { Component, PropTypes } from 'react';


const propTypes = {
  key: PropTypes.string.isRequired,
  value: PropTypes.string.isRequired,
  handleReset: PropTypes.func.isRequired
};

class CurrentFilterItem extends Component {
  constructor(props) {
    super(props);

  }

  handleReset(e) {
    e.preventDefault();
    this.props.handleReset(this.props.key);
  }

  render() {
    const { value } = this.props;
    return (
      <div className={styles.root}>
        <span className={styles.deleteIcon} onClick={this.handleReset()} />
        <p className={styles.text}>{value}</p>
      </div>
    )
  }

}

CurrentFilterItem.propTypes = propTypes;
export default CurrentFilterItem;