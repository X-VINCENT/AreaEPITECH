import React, {useState} from 'react';
import './index.scss';

interface SubChildrensProps {
  className?: string;
  element?: React.ReactNode;
  action?: () => void;
}

interface ChildrenProps {
  className?: string;
  element?: React.ReactNode;
  action?: () => void;
  subChildrens?: SubChildrensProps[];
  divider?: boolean;
}

interface MatProps {
  className?: string;
  mainItem: ChildrenProps | React.ReactNode;
  childrens?: ChildrenProps[];
}

const Mat: React.FC<MatProps> = ({
  className,
  mainItem,
  childrens
}) => {
  const [isMatOpen, setIsMatOpen] = useState(false);
  // @ts-ignore
  const mainItemElement = mainItem?.element ? mainItem.element : mainItem;
  // @ts-ignore
  const mainItemAction = mainItem?.action ? mainItem.action : () => setIsMatOpen(!isMatOpen);
  const [openedSubItems, setOpenedSubItems] = useState<number[]>([]);

  const blurAction = () => {
    setTimeout(
      () => setIsMatOpen(false),
      100)
  }

  const handleClickChildAction = (action: () => void) => {
    return () => {
      action();
      blurAction();
    }
  }

  const handleClickChildNoAction = (index: number) => () => {
    setOpenedSubItems((prevState) => {
      if (prevState.find((item) => item === index))
        return prevState.filter((item) => item !== index);
      return [...prevState, index];
    });
  }

  return (
    <div className={`Mat ${className ? className : ''}`}>
      <button className="main-item" onClick={mainItemAction}>
        {mainItemElement}
      </button>
      {childrens && isMatOpen &&
        <div className="childrens">
          {childrens.map((child, index) => (
            <>
              <div
                className={`child ${child.className ? child.className : ''}`}
                key={index}
                onClick={child.action ? handleClickChildAction(child.action) : handleClickChildNoAction(index)}
              >
                {child.element || (React.isValidElement(child) ? child : null)}
                {child.subChildrens && openedSubItems.find((item) => item === index) &&
                  <div className="sub-childrens">
                    {child.subChildrens.map((subItem, idx) => (
                      <button
                        className="sub-child"
                        key={idx}
                        onClick={subItem.action ? subItem.action : () => undefined}
                      >
                        {subItem.element || (React.isValidElement(subItem) ? subItem : null)}
                      </button>
                    ))}
                  </div>
                }
              </div>
              {child.divider && <div className="divider" key={`divider-${index}`} />}
            </>
          ))}
        </div>
      }
    </div>
  );
};

export default Mat;
