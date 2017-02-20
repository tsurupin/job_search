import React, { Component, PropTypes } from 'react';
import { CurrentFilterItem } from 'components';

const propTypes = {
  items: PropTypes.arrayOf(PropTypes.shape.isRequired).isRequired,
  handleReset: PropTypes.func.isRequired,
  handleResetTechKeyword: PropTypes.func.isRequired
};

class CurrentFilterBox extends Component {
  constructor(props) {
    super(props);
  }

  render() {
    const {
      items,
      handleReset,
      handleResetTechKeyword
    } = this.props;

    return(
      <section className='root'>
        {items.map((item, index) => {
          let name =Object.keys(item)[0];
          let value = item[name];
          return(
            <CurrentFilterItem
              key={index}
              name={name}
              value={value}
              handleReset={handleReset}
              handleResetTechKeyword={handleResetTechKeyword}
            />
          );
        })}
      </section>
    )
  }
}

CurrentFilterBox.propTypes = propTypes;
export default CurrentFilterBox;
